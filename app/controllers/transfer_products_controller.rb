class TransferProductsController < ApplicationController
  before_action :authenticate_user!
      
  check_authorization
  load_and_authorize_resource
  
  # GET /transfer_products
  # GET /transfer_products.json
  def index
    @title = t('view.transfer_products.index_title')
    date = params[:date] ? Date.parse(params[:date]) : Time.zone.today
    _start, _finish = date.beginning_of_month, date.end_of_month
    @transfer_products = TransferProduct.where(
      created_at: _start.._finish
    ).order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transfer_products }
    end
  end

  # GET /transfer_products/1
  # GET /transfer_products/1.json
  def show
    @title = t('view.transfer_products.show_title')
    @transfer_product = TransferProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transfer_product }
    end
  end

  # GET /transfer_products/new
  # GET /transfer_products/new.json
  def new
    @title = t('view.transfer_products.new_title')
    @transfer_product = TransferProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transfer_product }
    end
  end

  # POST /transfer_products
  # POST /transfer_products.json
  def create
    @title = t('view.transfer_products.new_title')
    @transfer_product = TransferProduct.new(params[:transfer_product])

    respond_to do |format|
      if @transfer_product.save
        Printer.print_transfer_report(@transfer_product)
        format.html { redirect_to @transfer_product, notice: t('view.transfer_products.correctly_created') }
        format.json { render json: @transfer_product, status: :created, location: @transfer_product }
      else
        format.html { render action: 'new' }
        format.json { render json: @transfer_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_products/1
  # DELETE /transfer_products/1.json
  def destroy
    @transfer_product = TransferProduct.find(params[:id])
    @transfer_product.destroy

    respond_to do |format|
      format.html { redirect_to transfer_products_url }
      format.json { head :ok }
    end
  end

  def autocomplete_for_product_name
    products = Product.find_by_code(params[:q])

    respond_to do |format|
      format.json { render json: products }
    end
  end
end
