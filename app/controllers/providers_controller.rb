class ProvidersController < ApplicationController
  before_filter :authenticate_user!
      
  check_authorization
  load_and_authorize_resource
  
  # GET /providers
  # GET /providers.json
  def index
    @title = t('view.providers.index_title')
    @searchable = true
    @providers = Provider.filtered_list(params[:q]).order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @providers }
    end
  end

  # GET /providers/1
  # GET /providers/1.json
  def show
    @title = t('view.providers.show_title')
    @provider = Provider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /providers/new
  # GET /providers/new.json
  def new
    @title = t('view.providers.new_title')
    @provider = Provider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @provider }
    end
  end

  # GET /providers/1/edit
  def edit
    @title = t('view.providers.edit_title')
    @provider = Provider.find(params[:id])
  end

  # POST /providers
  # POST /providers.json
  def create
    @title = t('view.providers.new_title')
    @provider = Provider.new(params[:provider])

    respond_to do |format|
      if @provider.save
        format.html { redirect_to @provider, notice: t('view.providers.correctly_created') }
        format.json { render json: @provider, status: :created, location: @provider }
      else
        format.html { render action: 'new' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /providers/1
  # PUT /providers/1.json
  def update
    @title = t('view.providers.edit_title')
    @provider = Provider.find(params[:id])

    respond_to do |format|
      if @provider.update_attributes(params[:provider])
        format.html { redirect_to @provider, notice: t('view.providers.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_provider_url(@provider), alert: t('view.providers.stale_object_error')
  end

  # DELETE /providers/1
  # DELETE /providers/1.json
  def destroy
    @provider = Provider.find(params[:id])
    @provider.destroy

    respond_to do |format|
      format.html { redirect_to providers_url }
      format.json { head :ok }
    end
  end

  def add_increase
    @provider = Provider.find(params[:id])

    all_ok = @provider.increase_all_products!(params[:add].to_f)
    
    respond_to do |format|
      if all_ok
        format.html { redirect_to @provider, notice: 'Todo actualizado' }
      else
        format.html { redirect_to @provider, error: 'Algo flasho' }
      end
    end
  end
end
