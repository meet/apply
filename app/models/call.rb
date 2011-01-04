# A call for applications.
class Call < ActiveRecord::Base
  
  validates_format_of :id, :with => /\A[a-z]+\Z/
  
  # The ActiveRecord model application class for this call.
  def app_class
    Kernel.const_get(id.titleize)
  end
  
  # The ActiveRecord model review class for this call, if any.
  def review_class
    begin
      Kernel.const_get("#{id.titleize}Review")
    rescue NameError
      nil
    end
  end 
  
  # Identifying columns for the app (not necessarily uniquely).
  def identity_columns_a
    (identity_columns || app_class.content_columns.first.name).split
  end
  
  # Identifying string for the app (not necessarily unique).
  def identify(app)
    identity_columns_a.map { |c| app[c] } .join(' ')
  end
  
end
