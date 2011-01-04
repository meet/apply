require 'test_helper'

class CallsControllerTest < ActionController::TestCase
  
  test "unsecure index should be forbidden" do
    get :index, {}, { :username => 'maxg' }
    assert_response :forbidden
  end
  
  test "secure index should require authorization" do
    request.env['HTTPS'] = 'on'
    get :index
    assert_response :unauthorized
  end
  
  test "secure index should include model" do
    request.env['HTTPS'] = 'on'
    get :index, {}, { :username => 'maxg' }
    assert_response :success
    assert_template 'calls/index'
    assert_select 'a[href=?]', call_path('panda')
  end
  
  test "unsecure edit should be forbidden" do
    get :edit, { :id => 'panda' }, { :username => 'maxg' }
    assert_response :forbidden
  end
  
  test "secure edit should require authorization" do
    request.env['HTTPS'] = 'on'
    get :edit, { :id => 'panda' }
    assert_response :unauthorized
  end
  
  test "secure edit should show model form" do
    request.env['HTTPS'] = 'on'
    get :edit, { :id => 'panda' }, { :username => 'maxg' }
    assert_response :success
    assert_template 'calls/edit'
  end
  
end
