module ApplicationHelper
  
  def public_host
    ENV['PUBLIC_HOST'] || request.host_with_port
  end
  
  def public_apply_url(options)
    apply_url(options.merge(:protocol => 'http', :host => public_host))
  end
  
end
