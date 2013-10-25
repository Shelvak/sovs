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
    
    Sale.positives.earn_between(@from_date, @to_date).each do |s, earn|
      @sales_earn[s] = earn
    end

    respond_with @sales_earn do |format|
      format.csv { render csv: @sales_earn, filename: @title }
    end
  end

  def payrolls
    @title = t('view.stats.payrolls.title')
    @date = params[:search][:date] if params[:search]
    @payrolls = Sale.payrolls_of_month(params[:search][:date]) if @date

    respond_to do |format|
      format.html
      format.json { render json: @payrolls }
    end
  end

  def print_payrolls
    notice = if Printer.print_payrolls(Date.parse(params[:date]))
      t('view.stats.send_to_print')
    else
      t('view.stats.print_error')
    end

    redirect_to :back, notice: notice
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
      
      sales = Sale.between(hour, hour + 59.minutes + 59.seconds)

      @day_stats[i] = {
        hour_total_sold: sales.sum(&:total_price), 
        hour_total_count: sales.positives.count 
      }
      @stats[:total_count] += @day_stats[i][:hour_total_count]
      @stats[:total_sold] += @day_stats[i][:hour_total_sold]
    end
  end

  def products_day_stats
    @title = t('view.stats.products_day_stats.title')
    @day = params[:search] ? Date.parse(params[:search][:date]) : Date.today
    @products = {}
    @quantities = { 'Kg' => 0.0, 'Un' => 0, 'g' => 0.0, 'ml' => 0.0, 'L' => 0.0 }

    Product.with_preference.each do |prod|
      quantity = prod.product_lines.at_day(@day).sum(&:quantity).round(3)

      @products[prod.to_s] = [quantity, prod.retail_unit].join(' ')
      @quantities[prod.retail_unit] += quantity 
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
