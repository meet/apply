# Handles application exporting.
class ExportController < ApplicationController
  
  before_filter :authenticate
  before_filter :call
  
  # Export all submitted applications.
  def index
    @apps = @call.app_class.all
  end
  
end
