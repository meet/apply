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
  
  test "should just show application when no reviewing" do
    app = pandas(:mei_xiang)
    
    request.env['HTTPS'] = 'on'
    get :show_or_edit, { :model => 'panda', :app_id => app.id }, { :username => 'sally' }
    assert_response :success
    assert_template 'review/show'
    assert_template 'review/_app'
    assert ! @templates.include?('review/_summary')
  end
  
  test "should show application and summary when reviewing closed" do
    app = zookeepers(:alice)
    
    request.env['HTTPS'] = 'on'
    get :show_or_edit, { :model => 'zookeeper', :app_id => app.id }, { :username => 'sally' }
    assert_response :success
    assert_template 'review/show'
    assert_template 'review/_app'
    assert @templates.include?('review/_summary') # To match negative syntax
  end
  
  test "should show existing review in form when reviewing open" do
    calls(:zookeeper).update_attribute(:reviewable, true)
    app = zookeepers(:bob)
    
    request.env['HTTPS'] = 'on'
    get :show_or_edit, { :model => 'zookeeper', :app_id => app.id }, { :username => 'ted' }
    assert_response :success
    assert_template 'review/edit'
    assert_template 'review/_app'
    assert_template 'review/_form'
    assert ! @templates.include?('review/_summary')
    assert_select 'h1', zookeepers(:bob).name
    assert_select 'form[action=?]', review_app_path(:model => 'zookeeper', :app_id => app.id)
    (1..5).each { |v| assert_select "input#review_experience_#{v}[type=radio]" }
    (1..5).each { |v| assert_select "input#review_panda_whispering_#{v}[type=radio]" }
    assert_select 'input#review_panda_whispering_[type=radio]'
    assert_select 'input#review_panda_whispering_3[type=radio]' do |elts|
      assert_equal 'checked', elts.first['checked']
    end
    assert_select 'input#review_lions[type=checkbox]' do |elts|
      assert_equal 'checked', elts.first['checked']
    end
    assert_select 'input#review_tigers[type=checkbox]' do |elts|
      assert_equal nil, elts.first['checked']
    end
    assert_select 'textarea#review_comment'
    assert_no_match /created/i, response.body
  end
  
  test "should show blank review form when reviewing open" do
    calls(:zookeeper).update_attribute(:reviewable, true)
    app = zookeepers(:eve)
    
    request.env['HTTPS'] = 'on'
    get :show_or_edit, { :model => 'zookeeper', :app_id => app.id }, { :username => 'ted' }
    assert_response :success
    assert_template 'review/edit'
    assert_template 'review/_app'
    assert_template 'review/_form'
    assert ! @templates.include?('review/_summary')
    assert_select 'h1', zookeepers(:eve).name
    assert_select 'form[action=?]', review_app_path(:model => 'zookeeper', :app_id => app.id)
  end
  
  test "should reject new review when reviews closed" do
    call = calls(:zookeeper)
    app = zookeepers(:eve)
    
    request.env['HTTPS'] = 'on'
    post :create_or_update, { :model => 'zookeeper', :app_id => app.id }, { :username => 'ted' }
    assert_response :success
    assert_template :call_noreview
    assert_nil call.review_class.find_by_app_reviewer_id_and_app_id('ted', app.id)
  end
  
  test "should accept new review when reviews open" do
    call = calls(:zookeeper)
    call.update_attribute(:reviewable, true)
    app = zookeepers(:eve)
    
    request.env['HTTPS'] = 'on'
    post :create_or_update, { :model => 'zookeeper', :app_id => app.id }, { :username => 'ted' }
    assert_redirected_to review_path(:model => 'zookeeper')
    assert_not_nil call.review_class.find_by_app_reviewer_id_and_app_id('ted', app.id)
  end
  
  test "should reject updated review when reviews closed" do
    call = calls(:zookeeper)
    app = zookeepers(:bob)
    
    request.env['HTTPS'] = 'on'
    post :create_or_update,
         { :model => 'zookeeper', :app_id => app.id, :review => { :experience => 1 } },
         { :username => 'ted' }
    assert_response :success
    assert_template :call_noreview
    assert_nil call.review_class.find_by_app_reviewer_id_and_app_id('ted', app.id).experience
  end
  
  test "should accept updated review when reviews open" do
    call = calls(:zookeeper)
    call.update_attribute(:reviewable, true)
    app = zookeepers(:bob)
    
    request.env['HTTPS'] = 'on'
    post :create_or_update,
         { :model => 'zookeeper', :app_id => app.id, :review => { :experience => 1 } },
         { :username => 'ted' }
    assert_redirected_to review_path(:model => 'zookeeper')
    assert_equal 1, call.review_class.find_by_app_reviewer_id_and_app_id('ted', app.id).experience
  end
  
end
