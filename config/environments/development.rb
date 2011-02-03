Apply::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  class Development
    def initialize(app)
      @app = app
    end
    def call(env)
      # Simulate HTTPS
      env['HTTP_X_FORWARDED_PROTO'] = 'https' if env['SERVER_NAME'] == '127.0.0.1'
      @app.call(env)
    end
  end
  config.middleware.insert 0, Development
  
  ENV['PUBLIC_HOST'] = 'localhost:3000'
  
  # Don't use secure session cookie
  config.session_store :cookie_store, :key => '_apply_session', :secure => false
  
end
