require 'test_helper'

class CallTest < ActiveSupport::TestCase
  
  class ::Walrus
  end
  
  test "IDs should be stringy and classy" do
    call = Call.create { |c| c.id = 'walrus' }
    call.save!
    assert_equal 'walrus', call.id
    assert_equal Walrus, call.app_class
    
    call = Call.create { |c| c.id = 'Alligator'}
    assert_equal ['is invalid'], call.errors[:id]
  end
  
  test "identify should work with or without columns" do
    call = calls(:panda)
    assert_equal 'Mei Xiang 1998-07-22', call.identify(pandas(:mei_xiang))
    
    call.identity_columns = nil
    assert_equal 'Tian Tian', call.identify(pandas(:tian_tian))
  end
  
end
