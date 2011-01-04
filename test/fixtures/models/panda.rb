# Panda application model
class Panda < ActiveRecord::Base
  validates_presence_of :name
  def photo=(photo)
    self.photo_id = photo.content_type
    super(photo.read)
  end
end
