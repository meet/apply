# Integration test with generic machinery for testing applications.
class AppIntegrationTest < ActionController::IntegrationTest
  
  Field = Struct.new(:name, :value)
  
  # Construct a single application form field response.
  def self.field(name, value)
    Field.new(name, value)
  end
  
  # Construct a test case. Takes a block that returns an array of fields.
  def self.test_submit_and_review_application(model)
    test "submit and review application" do
      fields = yield self
      
      call = Call.create(:open => true) { |c| c.id = model }
      
      # Get the application page and fill it out
      get "/#{model}"
      fields_for_data = fields.dup
      data = {}
      assert_select '*[name]' do |inputs|
        field = nil
        inputs.each do |input|
          if input['type'] == 'hidden'
            next
          elsif input['type'] == 'submit'
            assert fields_for_data.empty?
            next
          end
          
          # Before we go to the next field, might need to complete a date selector
          case input['name']
          when /\[.*\(2i\)\]$/
            data[input['name']] = field.value.month
            next
          when /\[.*\(3i\)\]$/
            data[input['name']] = field.value.day
            next
          end
          
          field = fields_for_data.shift
          
          case input['name']
          when /\[#{field.name}\]$/
            data[input['name']] = field.value
          when /\[#{field.name}\(1i\)\]$/
            data[input['name']] = field.value.year
          else
            flunk "Expected #{field.name} field, was #{input.name} #{input['name']}"
          end
        end
      end
      
      # Submit the application
      post "/#{model}", data
      assert_response :success
      assert_equal Hash.new, assigns(:app).errors
      assert_template :thanks
      assert_template "layouts/#{model}" # Rails bug #5247
      
      # Get the application just submitted
      app = call.app_class.find(assigns(:app).id)
      
      open_session do |s|
        # Log in
        s.extend(OpenIdAuthorization::MockOpenIdFetcher::Session)
        s.https!
        s.login "/review/#{model}/1", 'root', 'all-staff'
        s.get s.response.redirect_url
        
        # Check that responses appear on the review page
        downloads = {}
        fields.each do |field|
          header = s.assert_select('h3', {
            :text => CGI::escapeHTML(call.app_class.human_attribute_name(field.name)),
            :minimum => 0
          }).first
          if field.value.is_a? Rack::Test::UploadedFile
            path = download_path(:model => model, :app_id => 1, :column => field.name)
            s.assert_select header.parent, 'a[href=?]', path
            downloads[path] = field
          elsif field.value == true or field.value == false
            s.assert_select header.parent, 'p', field.value ? 'yes' : 'no'
          elsif field.name.to_s.ends_with? '_year'
            s.assert_select header.parent, 'p', field.value.year.to_s
          elsif header
            s.assert_select header.parent, 'p', field.value.to_s
          else
            s.assert_select 'h1', field.value.to_s
          end
        end
        
        # And check that uploads can be downloaded
        downloads.each do |path, field|
          fixture = field.value
          s.get path
          url = URI.parse(s.response.redirect_url)
          assert_equal 's3.amazonaws.com', url.host
          dir = "/#{ENV['S3_BUCKET']}/#{model}-#{field.name.to_s.pluralize}/"
          name = "1-#{call.identify(app, '-')}.#{fixture.original_filename.split('.').last}"
          assert_match /^#{dir}#{name}\?AWSAccessKeyId=.*&Expires=.*&Signature=.*$/, url.request_uri
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = url.port == Net::HTTP.https_default_port
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          response = http.request_get(url.request_uri)
          assert_equal fixture.read, response.body
          assert_equal fixture.content_type, response['Content-Type']
          assert_equal 'attachment', response['Content-Disposition']
        end
      end
    end
  end
end
