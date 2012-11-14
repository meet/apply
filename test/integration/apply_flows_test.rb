require 'test_helper'

class ApplyFlowsTest < ActionController::IntegrationTest
  
  def teardown
    Panda.all.each { |app| app.destroy }
  end
  
  test "call missing" do
    get '/'
    assert_response :missing
    assert_template :call_missing
  end
  
  test "call bad" do
    get '/alligator'
    assert_response :missing
    assert_template :call_bad
  end
  
  test "call closed" do
    get '/panda'
    assert_response :success
    assert_template :call_closed
    assert_template 'layouts/panda' # Rails bug #5247
  end
  
  test "submit incomplete application" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    get '/panda'
    assert_response :success
    assert_template :new
    assert_template 'layouts/panda' # Rails bug #5247
    assert_select 'form[action=/panda]'
    
    assert_no_difference('Panda.count') do    
      post '/panda'
      assert_response :success
      assert_template :new
      assert_select 'form[action=/panda]'
      assert_select '#apply-form-errors ul li'
    end
  end
  
  test "submit incomplete using suggestion" do
    get '/veterinarian'
    assert_response :success
    assert_template :new
    assert_select 'input[name=?]', 'app[specialty]', false
    assert_select 'select[name=?]', 'app[specialty]'
    
    post '/veterinarian', { 'app[specialty]' => 'Mammalia' }
    assert_response :success
    assert_template :new
    assert_select 'input[name=?]', 'app[specialty]', false
    assert_select 'select[name=?]', 'app[specialty]' do |elts|
      assert_select 'option[selected]', 'Mammalia'
    end
  end
  
  test "submit incomplete ignoring suggestion" do
    get '/veterinarian'
    assert_response :success
    assert_template :new
    assert_select 'input[name=?]', 'app[specialty]', false
    assert_select 'select[name=?]', 'app[specialty]'
    
    post '/veterinarian', { 'app[specialty]' => 'Myxini' }
    assert_response :success
    assert_template :new
    assert_select 'input[name=?]', 'app[specialty]' do |elts|
      assert_equal 'Myxini', elts.first['value']
    end
    assert_select 'select[name=?]', 'app[specialty]', false
  end
  
  test "submit minimal application" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    post '/panda', { 'app[name]' => 'Alice the Panda', 'app[cute]' => '1' }
    assert_response :success
    assert_template :thanks
    
    alice = Panda.find(assigns(:app).id)
    assert_in_delta Time.zone.now, alice.created_at, 0.1
    assert_equal 'Alice the Panda', alice.name
    assert_nil alice.birthday
    assert_nil alice.favorite_bamboo_vintage_year
    assert_nil alice.experience
    assert alice.cute
    assert ! alice.photo.file?
    assert_nil alice.photo_file_name
  end
  
  test "submit full application" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    post '/panda', {
      'app[name]' => 'Bob the Panda',
      'app[birthday(1i)]' => '1980',
      'app[birthday(2i)]' => '2',
      'app[birthday(3i)]' => '22',
      'app[favorite_bamboo_vintage_year(1i)]' => '1492',
      'app[experience]' => 'Nom nom nom. Nom nom nom.',
      'app[cute]' => '0',
      'app[photo]' => fixture_file_upload('files/panda.jpg', 'image/jpeg')
      # Reuters photo via www.telegraph.co.uk
    }
    assert_response :success
    assert_template :thanks
    
    bob = Panda.find(assigns(:app).id)
    assert_in_delta Time.zone.now, bob.created_at, 5.0
    assert_equal 'Bob the Panda', bob.name
    assert_equal Date.parse('Feb 22, 1980'), bob.birthday
    assert_equal Date.civil(1492), bob.favorite_bamboo_vintage_year
    assert_match /nom/, bob.experience
    assert ! bob.cute
    assert bob.photo.file?
    assert File.new('test/fixtures/files/panda.jpg').read == bob.photo.to_file.read
  end
  
  test "submit preview" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    get '/panda?preview=true'
    assert_response :success
    assert_template :new
    assert_template 'layouts/panda' # Rails bug #5247
    assert_select 'form[action=/panda?preview=true]'
      
    assert_no_difference('Panda.count') do
      post '/panda?preview=true', { 'app[name]' => 'Eve the Panda' }
      assert_response :success
      assert_template :thanks
      assert_select '#apply-preview-banner'
    end
  end
  
end
