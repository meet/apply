module CallHelper
  
  # Returns an open/closed status div.
  def openclose(text, open)
    if open
      content_tag(:div, "#{text} open", :class => 'openclose-is-open')
    else
      content_tag(:div, "#{text} closed", :class => 'openclose-is-close')
    end
  end
  
end