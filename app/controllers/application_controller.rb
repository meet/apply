class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  def logout
    reset_session
    redirect_to :root
  end
  
  private
    
    # Require an authenticated user, or initiate authentication. Also require SSL.
    def authenticate
      if not request.ssl?
        render :file => 'public/403', :layout => false, :status => 403 and return
      end
      
      if @current_user = session[:username]
        return
      end
      
      authorize_with_open_id(:required => [ :groups ]) do |result, identity_url, attributes|
        reset_session
        if result.successful? and attributes[:groups].include? 'allstaff'
          @current_user = session[:username] = attributes[:username]
          redirect_to request.url
        else
          @error = result.message || 'Staff only'
          render 'application/error', :status => 403
        end
      end
      raise "Authentication failed but did not render or redirect" unless performed?
    end
    
    # Require a valid application call.
    def call
      if not params[:model]
        render :call_missing, :status => 404 and return false
      end
      begin
        @call = Call.find(params[:model])
      rescue ActiveRecord::RecordNotFound
        render :call_bad, :status => 404 and return false
      end
    end
    
end
