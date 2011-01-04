# Handles application reviews.
class ReviewController < ApplicationController
  
  before_filter :authenticate
  before_filter :call
  
  # List of submitted applications.
  def index
    @apps = @call.app_class.all
    @reviews = @call.review_class.where(:app_reviewer_id => @current_user) if @call.review_class
  end
  
  # Show an application, with review form if reviewable.
  def show_or_edit
    @app = @call.app_class.find(params[:app_id])
    if @call.reviewable
      @review = @call.review_class.where(:reviewer => session[:username], :app => params[:app_id])
      render :edit
    elsif @call.review_class
      @reviews = @call.review_class.where(:app => params[:app_id])
      render :show
    else
      render :show
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
