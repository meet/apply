module ReviewHelper
  
  def app_response(app, col)
    content = app[col.name]
    return nil if content == nil or content == ''
    
    case col.type
    when :date
      if col.name.ends_with? '_year'
        return app[col.name].year
      else
        return app[col.name]
      end
      
    when :text
      return simple_format app[col.name]
      
    when :boolean
      return app[col.name] ? 'yes' : 'no'
      
    when :binary
      return link_to 'download', download_path(:app_id => app.id, :column => col.name)
      
    else
      return app[col.name]
      
    end
  end
  
  # Returns a form tag (input, radio buttons, etc.) for the given column.
  def review_input(call, name, col)
    case col.type
    when :integer
      # Numeric scale
      options = call.review_class.column_options(col)
      content_tag(:table,
        content_tag(:tr,
          options.map { |v| content_tag(:td, radio_button(name, col.name, v == '?' ? '' : v)) } .join.html_safe
        ) + content_tag(:tr,
          options.map { |v| content_tag(:td, v) } .join.html_safe
        )
      )
      
    when :text
      # Long answer text
      '<br/>'.html_safe + text_area(name, col.name, :size => '25x4')
      
    when :boolean
      # Checkbox
      check_box(name, col.name)
      
    end
  end
  
  def review_output(review, col)
    case col.type
    when :boolean
      review[col.name] ? 'yes' : 'no'
      
    when :text
      '<br/>'.html_safe + review[col.name]
      
    else
      review[col.name]
      
    end
  end
  
  def format_float(f)
    return '&mdash;'.html_safe if f == nil
    sprintf("%.1f", f).sub(/\.?0+$/,'')
  end
  
  def format_percent(f)
    return '&mdash;'.html_safe if f == nil
    sprintf("%.0f", f*100)
  end
  
end
