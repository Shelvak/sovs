class DailyBoxController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /daily_boxes
  # GET /daily_boxes.json
  def index
    @title = t('view.daily_box.index_title')
    @boxes = Sale.where(
      "#{Sale.table_name}.created_at > ?", 31.days.ago.beginning_of_day
    ).order("#{Sale.table_name}.created_at DESC").group_by(&:created_at_date)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boxes }
    end
  end
end
