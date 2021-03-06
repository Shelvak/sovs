class SalesController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /sales
  # GET /sales.json
  def index
    @title = t('view.sales.index_title')
    @sales = Sale.order('id DESC').page(params[:page])

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
    @sale.seller_code = session[:current_seller]
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

  # PUT /sales/1/revoke
  def revoke
    sale = Sale.find(params[:id])

    if sale.revoke!
      redirect_to sales_path, notice: t('view.sales.revoke_ok')
    else
      redirect_to sales_path, notice: t('view.sales.can_not_revoke')
    end
  end

  def daily_report
    if params[:to_print]
      if true # Printer.print_daily_report(params[:to_print][:date].to_date)
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
    products = Product.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: products }
    end
  end

  def sales_params
    params.require(:sale).permit(
      :customer_id, :seller_id, :sale_kind, :total_price,
      :seller_code, :auto_customer_name,
      :place_id, :default_price_type, product_lines_attributes: [
        :product_id, :quantity, :unit_price, :price_type
      ]
    )
  end
end
