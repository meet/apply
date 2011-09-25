# Panda application model
class Panda < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :name
  
  has_attached_s3_file :photo
  
end
