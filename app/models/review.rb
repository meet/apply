# Module to include in review model classes.
module Review
  
  # Is this review complete?
  def complete?
    self.class.form_columns.each do |c|
      case c.type
      when :integer
        # Must select a value for scales with no '?' option
        return false if self[c.name] == nil and not self.class.column_options(c).include?('?')
      end
    end
    return true
  end
  
  module ReviewClass
    
    # Content columns to include in review form.
    def form_columns
      content_columns.reject { |c| c.name == 'created_at' }
    end
    
    # Content columns that will be summarized to a number.
    def numeric_summary_columns
      form_columns.find_all { |c| [ :integer, :boolean ].include? c.type }
    end
    
    # Options specified by validates_inclusion_of.
    def column_options(col)
      validators = validators_on(col.name)
      validators.find{ |v| v.is_a? ActiveModel::Validations::InclusionValidator } .options[:in]
    end
    
    # Compute a summary of reviews for the given application.
    def summarize(app)
      reviews = self.where(:app_id => app.id)
      return nil if reviews.empty?
      
      # Quacks like a review model instance, but values are not typecast
      summary = Struct.new(*(form_columns.map { |c| c.name.to_sym } << :app)).new
      summary.app = app
      form_columns.each do |c|
        nonempty = reviews.find_all { |r| r[c.name] != nil and r[c.name] != '' }
        case c.type
        when :integer # -> average
          summary[c.name] = nonempty.map { |r| r[c.name].to_f } .sum(None) / nonempty.count
        when :boolean # -> percent true
          summary[c.name] = nonempty.map { |r| r[c.name] ? 1.0 : 0.0 } .sum(None) / nonempty.count
        else          # -> map of username to review value
          summary[c.name] = Hash[nonempty.map { |r| [ r.app_reviewer_id, r[c.name] ] }]
        end
      end
      return summary
    end
    
    module None
      def self./(x)
        raise ZeroDivisionError.new("expected divide by 0, not #{x}") unless x == 0
        return 0
      end
    end
    
  end
  
  def self.included(base)
    base.extend(ReviewClass)
    
    base.attr_protected :app_reviewer_id, :app_id
    
    base.validates_presence_of :app_reviewer_id, :app_id
  end
  
end
