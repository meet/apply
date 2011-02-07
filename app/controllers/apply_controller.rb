# Handles presenting application forms and receiving submissions.
class ApplyController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  before_filter :call
  before_filter :preview
  before_filter :late
  
  layout :call_layout
  
  # Render the application form.
  def new
    if @call.open || (@late && @current_user)
      @app = @call.app_class.new
      render :new
    else
      render :call_closed
    end
  end
  
  # Process a submitted application form.
  def create
    @app = @call.app_class.new(params[:app])
    if (@preview ? @app.valid? : @app.save)
      render :thanks
    else
      render :new
    end
  end
  
  private
    
    def preview
      @preview = params[:preview] != nil
    end
    
    def late
      if @late = params[:late] != nil
        authenticate
      end
    end
    
    # Set view layout based on the current application call.
    def call_layout
      @call ? @call.id : 'application'
    end
    
end
