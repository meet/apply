# Listing and editing calls for applications.
class CallsController < ApplicationController
  
  before_filter :authenticate
  
  # List of calls for applications.
  def index
    @calls = Call.all
  end
  
  # Form for editing a call.
  def edit
    @call = Call.find(params[:id])
  end
  
  # Update a call.
  def update
    @call = Call.find(params[:id])
    
    respond_to do |format|
      if @call.update_attributes(params[:call])
        format.html { redirect_to call_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
end
