class DailyBoxController < ApplicationController
  before_filter :authenticate_user!, :authorize_daily_box!
  
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

  def print_daily_report
    date = Date.parse(params[:date])
    flash.notice = if Printer.print_daily_report(date)
      t('view.daily_boxes.send_to_print', day: l(date))
    else
      t('view.stats.print_error')
    end

    respond_to do |format|
      format.html { redirect_to daily_boxes_path }
      format.json { head :ok }
    end
  end

  private

  def authorize_daily_box!
    authorize! :daily_box, :all
  end
end
