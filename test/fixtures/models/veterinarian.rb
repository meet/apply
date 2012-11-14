# Veterinarian application model
class Veterinarian < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :name
  validates_presence_of :specialty, :suggest => [
    'Amphibia',
    'Aves',
    'Chondrichthyes',
    'Mammalia',
    'Osteichthyes',
    'Reptilia',
    'Synapsida'
  ]
  
end
