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
      format.json { render json: @sales }
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

  # GET /sales/1/edit
  def edit
    @title = t('view.sales.edit_title')
    @sale = Sale.find(params[:id])
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

  # PUT /sales/1
  # PUT /sales/1.json
  def update
    @title = t('view.sales.edit_title')
    @sale = Sale.find(params[:id])

    respond_to do |format|
      if @sale.update_attributes(params[:sale])
        format.html { redirect_to @sale, notice: t('view.sales.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_sale_url(@sale), alert: t('view.sales.stale_object_error')
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url }
      format.json { head :ok }
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
end
