class StatsController < ApplicationController
  before_filter :authenticate_user!, :load_date_range, :authorize_stats!
  respond_to :html, :json, :csv

  def index
    @title = t('view.stats.index_title')
  end
  
  def sales_by_seller
    @title = t('view.stats.sales_by_seller.title')
    @sales_by_seller_count = {}
    
    Sale.stats_by_seller_between(@from_date, @to_date).each do |seller, stat|
      @sales_by_seller_count[seller] = stat
    end

    respond_with @sales_by_seller_count do |format|
      format.csv { render csv: @sales_by_seller_count, filename: @title }
    end
  end

  def sales_earn
    @title = t('view.stats.sales_earn.title')
    @sales_earn = {}
    
    Sale.earn_between(@from_date, @to_date).each do |s, earn|
      @sales_earn[s] = earn
    end

    respond_with @sales_earn do |format|
      format.csv { render csv: @sales_earn, filename: @title }
    end
  end

  def payrolls
    @title = t('view.stats.payrolls.title')
    @payrolls = Sale.payrolls_of_month(params[:search][:date]) if params[:search]

    respond_to do |format|
      format.html
      format.json { render json: @payrolls }
    end
  end

  def sales_by_hours
    @title = t('view.stats.sales_by_hours.title')
    @day_stats = {}
    @stats = { total_count: 0, total_sold: 0.0 }

    @day = if params[:search]
      Date.parse(params[:search][:date])
    else
      Time.zone.now.to_date
    end

    (8..21).each do |i|
      hour = Time.zone.parse("#{@day} #{i}:00:00")
      
      sales = Sale.where(
        "created_at >= :start AND  created_at <= :final",
        start: hour, final: (hour + 59.minutes + 59.seconds)
      )

      @day_stats[i] = {
        hour_total_sold: sales.sum(&:total_price), 
        hour_total_count: sales.count 
      }
      @stats[:total_count] += @day_stats[i][:hour_total_count]
      @stats[:total_sold] += @day_stats[i][:hour_total_sold]
    end
  end

  private

  def authorize_stats!
    authorize! :stats, :all
  end
  
  def load_date_range
    @from_date, @to_date = *make_datetime_range(params[:interval])
  end
end
