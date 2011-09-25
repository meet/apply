# Summer technical instructor applications.
class Instructor < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :first_name, :last_name, :major
  validates_inclusion_of :status, :in => [ 'Undergraduate', 'Grad student', 'Alumnus/a' ]
  validates_presence_of :graduation_year, :unless => "status == 'Grad student'"
  validates_presence_of :why_meet
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  has_attached_s3_file :resume
  validates_attachment_presence :resume
  
end
