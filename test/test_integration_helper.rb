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
        s.login "/review/#{model}/1", 'root', 'allstaff'
        s.get s.response.redirect_url
        
        # Check that responses appear on the review page
        downloads = {}
        fields.each do |field|
          if field.value.is_a? Rack::Test::UploadedFile
            path = download_path(:model => model, :app_id => 1, :column => field.name)
            s.assert_select 'a[href=?]', path
            downloads[path] = field.value
          elsif field.name.to_s.ends_with? '_year'
            s.assert_select 'p,h1,h2,h3', field.value.year.to_s
          else
            s.assert_select 'p,h1,h2,h3', field.value.to_s
          end
        end
        
        # And check that uploads can be downloaded
        downloads.each do |path, fixture|
          s.get path
          assert_equal fixture.read, response.body
          assert_equal fixture.content_type, response.headers['Content-Type']
          ext = fixture.original_filename.split('.').last
          assert_match /filename="#{call.identify(app)}.#{ext}"/, response.headers['Content-Disposition']
        end
      end
    end
  end
end
