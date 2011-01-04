# Summer business instructor applications.
class Business < ActiveRecord::Base
  
  validates_presence_of :first_name, :last_name, :major, :graduation_year
  validates_presence_of :why_meet
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of :resume
  
  default_scope order(:first_name, :last_name)
  
  def resume=(resume)
    self.resume_id = resume.content_type
    super(resume.read)
  end
  
end
