class SellersController < ApplicationController
  before_action :authenticate_user!
      
  check_authorization
  load_and_authorize_resource
  
  # GET /sellers
  # GET /sellers.json
  def index
    @title = t('view.sellers.index_title')
    @sellers = Seller.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sellers }
    end
  end

  # GET /sellers/1
  # GET /sellers/1.json
  def show
    @title = t('view.sellers.show_title')
    @seller = Seller.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @seller }
    end
  end

  # GET /sellers/new
  # GET /sellers/new.json
  def new
    @title = t('view.sellers.new_title')
    @seller = Seller.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @seller }
    end
  end

  # GET /sellers/1/edit
  def edit
    @title = t('view.sellers.edit_title')
    @seller = Seller.find(params[:id])
  end

  # POST /sellers
  # POST /sellers.json
  def create
    @title = t('view.sellers.new_title')
    @seller = Seller.new(params[:seller])

    respond_to do |format|
      if @seller.save
        format.html { redirect_to @seller, notice: t('view.sellers.correctly_created') }
        format.json { render json: @seller, status: :created, location: @seller }
      else
        format.html { render action: 'new' }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sellers/1
  # PUT /sellers/1.json
  def update
    @title = t('view.sellers.edit_title')
    @seller = Seller.find(params[:id])

    respond_to do |format|
      if @seller.update_attributes(params[:seller])
        format.html { redirect_to @seller, notice: t('view.sellers.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_seller_url(@seller), alert: t('view.sellers.stale_object_error')
  end

  # DELETE /sellers/1
  # DELETE /sellers/1.json
  def destroy
    @seller = Seller.find(params[:id])
    @seller.destroy

    respond_to do |format|
      format.html { redirect_to sellers_url }
      format.json { head :ok }
    end
  end
end
