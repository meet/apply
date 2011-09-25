module ReviewHelper
  
  def app_response(app, col)
    content = app[col.name]
    return nil if content == nil or content == ''
    
    case col.field_type
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
      
    when :paperclip
      return link_to 'download', download_path(:app_id => app.id, :column => col.field_name)
      
    else
      return app[col.name]
      
    end
  end
  
  def app_summary_response(call, app, col)
    content = app[col.name]
    return nil if content == nil or content == ''
    
    case col.field_type
    when :text
      return link_to_function('&para;'.html_safe) do |page|
        page.call('summary_reveal', page.literal('event'),
                                    call.identify(app),
                                    app.class.human_attribute_name(col.name),
                                    app_response(app, col))
      end
      
    when :paperclip
      return link_to '&darr;'.html_safe, download_path(:app_id => app.id, :column => col.field_name)
      
    else
      return app_response(app, col)
      
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
  
  def review_summary_output(call, summary, col)
    return nil if summary == nil
    content = summary[col.name]
    return nil if content == nil or content == {}
    
    case col.type
    when :integer
      sprintf("%.1f", content).sub(/\.?0+$/,'')
      
    when :boolean
      sprintf("%.0f", content*100)
      
    else
      return link_to_function('&para;'.html_safe) do |page|
        page.call('summary_reveal', page.literal('event'),
                                    call.identify(summary.app),
                                    call.review_class.human_attribute_name(col.name).pluralize,
                                    review_summary_full_output(summary, col))
      end
      
    end
  end
  
  def review_summary_full_output(summary, col)
    return nil if summary == nil
    content = summary[col.name]
    return nil if content == nil
    
    content.keys.sort.map do |username|
      content_tag(:p,
        content_tag(:b, username) + ': ' + content[username])
    end .join.html_safe
  end
  
end
