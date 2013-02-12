class SalesController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource
  
  # GET /sales
  # GET /sales.json
  def index
    @title = t('view.sales.index_title')
    @sales = Sale.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sales.to_json(include: :product_lines) }
    end
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
    @title = t('view.sales.show_title')
    @sale = Sale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale }
    end
  end

  # GET /sales/new
  # GET /sales/new.json
  def new
    @title = t('view.sales.new_title')
    @sale = Sale.new
    @sale.product_lines.build unless @sale.product_lines.any?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale }
    end
  end

  # POST /sales
  # POST /sales.json
  def create
    @title = t('view.sales.new_title')
    @sale = Sale.new(params[:sale])

    respond_to do |format|
      if @sale.save
        format.html { redirect_to new_sale_path, notice: t('view.sales.correctly_created') }
        format.json { render json: @sale, status: :created, location: @sale }
      else
        format.html { render action: 'new' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def daily_report
    if params[:to_print]
      if Printer.print_daily_report(params[:to_print][:date].to_date)
        redirect_to sales_url, notice: 'Se imprimio el informe'
      end
    end
  end

  def autocomplete_for_customer_name
    customers = Customer.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: customers }
    end
  end

  def autocomplete_for_product_name
    products = Product.with_code(params[:q]).limit(1)

    respond_to do |format|
      format.json { render json: products }
    end
  end
end
