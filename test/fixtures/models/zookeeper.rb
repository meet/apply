# Zookeeper application model
class Zookeeper < ActiveRecord::Base
  validates_presence_of :name
end

# Reviews of zookeeper applications
class ZookeeperReview < ActiveRecord::Base
  
  include Review
  
  validates_inclusion_of :experience, :in => 1..5, :allow_nil => true
  validates_inclusion_of :panda_whispering, :in => (1..5).to_a << '?', :allow_nil => true
  
end
