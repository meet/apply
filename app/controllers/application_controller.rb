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
        render :file => 'public/403', :layout => false, :status => 403
        return false
      end
      
      if @current_user = session[:username]
        return true
      end
      
      authorize_with_open_id(:required => [ :groups ]) do |result, identity_url, attributes|
        reset_session
        if result.successful?
          if attributes[:groups].include? 'allstaff'
            @current_user = session[:username] = attributes[:username]
            return true
          else
            render :file => 'public/403', :layout => false, :status => 403
          end
        else
          render :text => result.message, :status => 403
        end
      end
      return false
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
