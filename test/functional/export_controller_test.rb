require 'test_helper'

class ExportControllerTest < ActionController::TestCase
  
  test "unsecure index should be forbidden" do
    get :index, { :model => 'panda' }, { :username => 'maxg' }
    assert_response :forbidden
  end
  
  test "secure index should require authorization" do
    request.env['HTTPS'] = 'on'
    get :index, { :model => 'panda' }
    assert_response :unauthorized
  end
  
  test "CSV file includes application data" do
    request.env['HTTPS'] = 'on'
    get :index, { :model => 'panda', :format => 'csv' }, { :username => 'maxg' }
    assert_response :success
    assert_template :index
    data = false
    response.body.split("\n").each do |line|
      values = line.split(',')
      data = {} and next if values[0] == 'ID'
      data[values[0].to_i] = values if data
    end
    assert data[pandas(:mei_xiang).id].find { |val| val =~ /#{pandas(:mei_xiang).name}/ }
    assert data[pandas(:tian_tian).id].find { |val| val =~ /#{pandas(:tian_tian).birthday}/ }
  end
  
end
