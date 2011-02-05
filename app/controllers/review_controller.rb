# Handles application reviews.
class ReviewController < ApplicationController
  
  before_filter :authenticate
  before_filter :call
  
  # List of submitted applications.
  def index
    @apps = @call.app_class.all
    if @call.reviewable
      srand @current_user.bytes.reduce(0x100, :^)
      @apps = @apps.sort_by { rand }
    end
    @reviews = @call.review_class.where(:app_reviewer_id => @current_user) if @call.review_class
  end
  
  # Show an application, with review form if reviewable.
  def show_or_edit
    @app = @call.app_class.find(params[:app_id])
    if @call.reviewable
      # Reviews are open
      @review = @call.review_class.find_or_initialize_by_app_reviewer_id_and_app_id(@current_user, @app.id)
      render :edit
    elsif @call.review_class
      # Reviews are closed
      @review = @call.review_class.find_by_app_reviewer_id_and_app_id(@current_user, @app.id)
      @summary = @call.review_class.summarize(@app.id)
      render :show
    else
      # No reviewing
      render :show
    end
  end
  
  # Create or update the user's review of the application.
  def create_or_update
    @app = @call.app_class.find(params[:app_id])
    if not @call.reviewable
      render :call_noreview and return
    end
    
    @review = @call.review_class.find_or_initialize_by_app_reviewer_id_and_app_id(@current_user, @app.id)
    @review.attributes = params[:review]
    
    if @review.save
      redirect_to review_path
    else
      render :edit
    end
  end
  
  # Download a file uploaded with an application.
  def download
    @app = @call.app_class.find(params[:app_id])
    content_type = Mime::Type.lookup(@app["#{params[:column]}_id"])
    extension = Mime::EXTENSION_LOOKUP.invert[content_type]
    send_data @app[params[:column]],
              :filename => "#{@call.identify(@app)}.#{extension}",
              :type => content_type, :disposition => 'inline'
  end
  
end
