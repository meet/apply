# Panda application model
class Panda < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :name
  
end
