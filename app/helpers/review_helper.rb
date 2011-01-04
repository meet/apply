module ReviewHelper
  
  def app_response(app, col)
    content = app[col.name]
    return '&mdash;'.html_safe if content == nil or content == ''
    
    case col.type
    when :date
      if col.name.ends_with? '_year'
        return app[col.name].year
      else
        return app[col.name]
      end
      
    when :binary
      link_to 'download', download_path(:column => col.name)
      
    else
      return app[col.name]
      
    end
  end
  
end
