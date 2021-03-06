module ApplyHelper
  
  # Returns a mailto: link.
  def contact
    '<a href="mailto:info@meet.mit.edu">info@meet.mit.edu</a>'.html_safe
  end
  
  # Returns a form tag (input, select, etc.) for the given column.
  def app_input(call, name, col)
    validators = call.app_class.validators_on(col.name)
    
    case col.field_type
    when :string, :integer
      if validator = validators.find{ |v| v.is_a? ActiveModel::Validations::InclusionValidator }
        # Fixed set of options
        select name, col.name, validator.options[:in], :include_blank => true
      elsif validator = validators.find{ |v| v.is_a? ActiveModel::Validations::PresenceValidator and v.options[:suggest] }
        # Fixed set of options, or other
        pick = instance_variable_get("@#{name}")[col.name]
        if pick and not pick.empty? and not validator.options[:suggest].include?(pick)
          text_field name, col.name
        else
          select name, col.name, validator.options[:suggest] + [ '-Other-' ], :include_blank => true
        end
      else
        # Short answer text
        text_field name, col.name
      end
      
    when :text
      # Long answer text
      text_area name, col.name, :size => '60x10'
      
    when :date
      year = Time.now.year
      options = if col.name.ends_with? '_year'
        # Year only
        { :discard_month => true, :start_year => year - 15, :end_year => year + 10 }
      else
        # Day, month, and year
        { :start_year => year - 25, :end_year => year - 10 }
      end
      options.merge!({ :include_blank => true })
      date_select name, col.name, options
      
    when :boolean
      # Checkbox
      check_box name, col.name
      
    when :paperclip
      # File upload
      file_field name, col.field_name
      
    end
  end
  
  # Returns the label tag for an input field, with line breaks permitted only between sentences.
  def sentential_label(object_name, method)
    text = h(I18n.t(method, :scope => [ :helpers, :label, object_name ] ))
    text = text.gsub /[^ ].*?[\.\?]/ do |s|
      content_tag :span, s, :class => 'nowrap'
    end
    label object_name, method, text.html_safe
  end
  
end
