require 'test_helper'

class ReviewControllerTest < ActionController::TestCase
  
  test "unsecure index should be forbidden" do
    get :index, { :model => 'walrus' }, { :username => 'maxg' }
    assert_response :forbidden
  end
  
  test "secure index should require authorization" do
    request.env['HTTPS'] = 'on'
    get :index, { :model => 'walrus' }
    assert_response :unauthorized
  end
  
  test "bad call should error out" do
    request.env['HTTPS'] = 'on'
    get :index, { :model => 'walrus' }, { :username => 'maxg' }
    assert_response :missing
    assert_template 'review/call_bad'
  end
  
  test "should show applications index" do
    request.env['HTTPS'] = 'on'
    get :index, { :model => 'panda' }, { :username => 'maxg' }
    assert_response :success
    assert_template 'review/index'
    assert_select 'a[href=?]', review_app_path(:model => 'panda', :app_id => pandas(:mei_xiang).id)
  end
  
end
