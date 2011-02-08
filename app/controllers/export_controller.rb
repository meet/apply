# Handles application exporting.
class ExportController < ApplicationController
  
  before_filter :authenticate
  before_filter :call
  
  # Export all submitted applications.
  def index
    @apps = @call.app_class.unscoped.all(:order => :id)
  end
  
end
