class ProductsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource
  
  # GET /products
  # GET /products.json
  def index
    @title = t('view.products.index_title')
    @searchable = true
    products = if params[:provider_id]
                 @provider = Provider.find(params[:provider_id])
                 @provider.products
               elsif params[:status] == 'low_stock'
                 Product.with_low_stock
               else
                 Product.scoped
               end

    @products = products.filtered_list(params[:q]).order(:code).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @title = t('view.products.show_title')
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @title = t('view.products.new_title')
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @title = t('view.products.edit_title')
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @title = t('view.products.new_title')
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t('view.products.correctly_created') }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @title = t('view.products.edit_title')
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: t('view.products.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_product_url(@product), alert: t('view.products.stale_object_error')
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :ok }
    end
  end

  def autocomplete_for_provider_name
    providers = Provider.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: providers }
    end
  end

  def put_to_stock
    product = Product.find(params[:id])

    notice = product.put_to_stock(params[:quantity].to_f) ? 
      t('view.products.stock_correctly_updated') :
      t('view.products.stale_object_error')

    respond_to do |format|
      format.html { redirect_to :back, notice: notice }
      format.json { render json: product }
    end
  end
end
