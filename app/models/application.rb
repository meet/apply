# Module to include in application model classes.
module Application
  
  def as_json(options = {})
    json = Hash[self.class.export_columns.map { |c| [ c.name, self[c.name] ] }]
    json[:id] = id
    json[:identity] = self.class.call.identify(self)
    return json
  end
  
  module ApplicationClass
    
    def call
      Call.where(:id => name.downcase).first
    end
    
    # Content columns to include in application form.
    def form_columns
      content_columns.reject { |c| c.name == 'created_at' }
    end
    
    # Content columns to include in exports.
    def export_columns
      content_columns.reject { |c| [ :text, :paperclip ].include? c.field_type }
    end
    
    # Should be private
    
    def order_by_identity_columns
      default_scope order(*call.identity_columns_a) if call
    end
    
    def has_attached_s3_file(column)
      has_attached_file column,
                        :storage => :s3,
                        :bucket => ENV['S3_BUCKET'],
                        :s3_credentials => {
                          :access_key_id => ENV['S3_KEY'],
                          :secret_access_key => ENV['S3_SECRET']
                        },
                        :s3_permissions => :authenticated_read,
                        :s3_headers => { 'Content-Disposition' => 'attachment' },
                        :path => "/#{name.downcase}-:attachment/:id-:app_identity.:extension"
    end
    
  end
  
  def self.included(base)
    base.extend(ApplicationClass)
    
    base.order_by_identity_columns
  end
  
end

module ActiveRecord
  module ConnectionAdapters
    class Column
      
      def field_name
        case name
        when /(.*)_file_name$/
          return $1
        end
        return name
      end
      
      def field_type
        case name
        when /_file_name$/
          return :paperclip
        end
        return type
      end
      
    end
  end
end
