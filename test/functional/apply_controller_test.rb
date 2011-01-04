require 'test_helper'

class ApplyControllerTest < ActionController::TestCase
  
  test "missing call should error out" do
    get :new
    assert_response :missing
    assert_template 'apply/call_missing'
  end
  
  test "bad call should error out" do
    get :new, :model => 'walrus'
    assert_response :missing
    assert_template 'apply/call_bad'
  end
  
  test "should show closed application page" do
    get :new, :model => 'panda'
    assert_response :success
    assert_template 'apply/call_closed'
    assert_template 'layouts/panda' # Rails bug #5247
  end
  
  test "should show application page" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    get :new, :model => 'panda'
    assert_response :success
    assert_template 'apply/new'
    assert_template 'layouts/panda' # Rails bug #5247
    assert_select 'h1', call.title
    assert_select 'form[action=?]', apply_path(:model => 'panda')
    assert_select 'input#app_name[type=text]'
    assert_select 'select#app_birthday_1i'
    assert_select 'select#app_birthday_2i'
    assert_select 'select#app_birthday_3i'
    assert_select 'select#app_favorite_bamboo_vintage_year_1i'
    assert_select 'textarea#app_experience'
    assert_select 'input#app_cute[type=checkbox]'
    assert_select 'input#app_photo[type=file]'
    assert_no_match /created/i, response.body
  end
  
  test "should show application preview" do
    call = Call.find('panda')
    call.update_attribute(:open, true)
    
    get :new, :model => 'panda', :preview => true
    assert_response :success
    assert_template 'apply/new'
    assert_template 'layouts/panda' # Rails bug #5247
    assert_select 'h1', call.title
    assert_select 'form[action=?]', apply_path(:model => 'panda', :preview => true)
  end
  
end
