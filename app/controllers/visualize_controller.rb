# Handles application review summaries.
class VisualizeController < ApplicationController
  
  before_filter :authenticate
  before_filter :call
  before_filter :state
  
  TOGGLE_STATES = [ :neutral, :down, :up ]
  
  # Toggle, store, and update page with applicant judgement state.
  def toggle
    @app = @call.app_class.find(params[:app_id])
    before = @toggles[@app.id]
    after = @toggles[@app.id] = TOGGLE_STATES[TOGGLE_STATES.index(before)-1]
    render :update do |page|
      page.call('visualize_toggle', @app.id, before, after)
    end
  end
  
  # Store an axis selection.
  def axis
    @axes[params[:axis]] = params[:value]
    render :nothing => true
  end
  
  # Update page to include application review details.
  def details
    @app = @call.app_class.find(params[:app_id])
    @summary = @call.review_class.summarize(@app)
    render :update do |page|
      page.insert_html :top, :details, :partial => 'review/summary'
      page.insert_html :top, :details, :partial => 'heading'
    end
  end
  
  # Table view of summarized applications and reviews.
  def table
    reviewable_apps_and_summaries or render :call_inreview
  end
  
  # Scatterplot visualization of summarized reviews.
  def scatter
    if reviewable_apps_and_summaries
      @json = summaries_json
    else
      render :call_inreview
    end
  end
  
  # Scatterplot matrix visualization of summarized reviews.
  def splom
    if reviewable_apps_and_summaries
      @json = summaries_json
    else
      render :call_inreview
    end
  end
  
  private
    
    def state
      @toggles = session[:visualize_toggle] ||= Hash.new(TOGGLE_STATES.first)
      @axes = session[:visualize_axes] ||= {}
    end
    
    def reviewable_apps_and_summaries
      return false if @call.reviewable
      
      @apps = @call.app_class.all
      @summaries = Hash[@apps.map { |app| [ app.id, @call.review_class.summarize(app) ] }]
      return true
    end
    
    def summaries_json
      return {
        :properties => @call.review_class.numeric_summary_columns.map { |c| {
          :name => c.name, :display => @call.review_class.human_attribute_name(c.name) } },
        :summaries => @summaries.values.map { |s| Hash[*s.members.zip(s.values).flatten] },
        :toggles => @toggles
      }.to_json
    end
    
end
