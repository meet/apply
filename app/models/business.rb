# Summer business instructor applications.
class Business < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :first_name, :last_name, :major, :graduation_year
  validates_presence_of :why_meet
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of :resume
  
end
