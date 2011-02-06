# Module to include in application model classes.
module Application
  
  module ApplicationClass
    
    def call
      Call.where(:id => name.downcase).first
    end
    
    # Should be private
    
    def order_by_identity_columns
      default_scope order(*call.identity_columns_a) if call
    end
    
    def define_binary_setter(col)
      define_method "#{col.name}=" do |upload|
        self["#{col.name}_id"] = upload.content_type
        super(upload.read)
      end
    end
    
  end
  
  def self.included(base)
    base.extend(ApplicationClass)
    
    base.order_by_identity_columns
    
    base.content_columns.find_all { |c| c.type == :binary } .each do |c|
      base.define_binary_setter(c)
    end
  end
  
end
