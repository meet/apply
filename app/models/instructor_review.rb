# Reviews of instructor applications.
class InstructorReview < ActiveRecord::Base
  
  include Review
  
  validates_inclusion_of :enthusiasm, :in => 1..5, :allow_nil => true
  validates_inclusion_of :programming, :in => (1..5).to_a << '?', :allow_nil => true
  validates_inclusion_of :teaching, :in => 1..5, :allow_nil => true
  validates_inclusion_of :teamwork, :in => 1..3, :allow_nil => true
  validates_inclusion_of :overall, :in => 1..7, :allow_nil => true
  
end
