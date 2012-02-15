# MEET Fellowship applications.
class Fellow < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :first_name, :last_name, :major, :affiliation
  validates_presence_of :why_fellow
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  has_attached_s3_file :resume
  validates_attachment_presence :resume
  
end
