require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  test "should protect and validate association columns" do
    review = calls(:zookeeper).review_class.new(:app_reviewer_id => 'user', :app_id => 1)
    assert_nil review.app_reviewer_id
    assert_nil review.app_id
    
    assert review.invalid?
    assert ! review.errors[:app_reviewer_id].empty?
    assert ! review.errors[:app_id].empty?
  end
  
  test "should get form columns" do
    assert_equal [ 'experience', 'panda_whispering', 'lions', 'tigers', 'comment' ],
                 calls(:zookeeper).review_class.form_columns.map { |c| c.name }
  end
  
  test "should be complete when required scales answered" do
    assert zookeeper_reviews(:sally_bob).complete?
    assert ! zookeeper_reviews(:ted_bob).complete?
  end
  
  test "summarizing" do
    alice = calls(:zookeeper).review_class.summarize(zookeepers(:alice).id)
    assert_equal 4, alice.experience
    assert_equal 4.5, alice.panda_whispering
    assert_equal 0.5, alice.lions
    assert_equal 0.5, alice.tigers
    assert_equal({ 'sally' => 'Interview', 'ted' => 'I like her' }, alice.comment)
    
    bob = calls(:zookeeper).review_class.summarize(zookeepers(:bob).id)
    assert_equal 4, bob.experience
    assert_equal 3.5, bob.panda_whispering
    assert_equal 1, bob.lions
    assert_equal 0, bob.tigers
    assert_equal({ 'ted' => 'I like him' }, bob.comment)
    
    eve = calls(:zookeeper).review_class.summarize(zookeepers(:eve).id)
    assert_equal 2, eve.experience
    assert_equal 2, eve.panda_whispering
    assert_equal 0, eve.lions
    assert_equal 0, eve.tigers
    assert_equal({ }, eve.comment)
  end
  
end
