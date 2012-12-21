class PlacesController < ApplicationController
  
  # GET /places
  # GET /places.json
  def index
    @title = t('view.places.index_title')
    @places = Place.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @places }
    end
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @title = t('view.places.show_title')
    @place = Place.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @place }
    end
  end

  # GET /places/new
  # GET /places/new.json
  def new
    @title = t('view.places.new_title')
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @place }
    end
  end

  # GET /places/1/edit
  def edit
    @title = t('view.places.edit_title')
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.json
  def create
    @title = t('view.places.new_title')
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        format.html { redirect_to places_url, notice: t('view.places.correctly_created') }
        format.json { render json: @place, status: :created, location: @place }
      else
        format.html { render action: 'new' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.json
  def update
    @title = t('view.places.edit_title')
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to places_url, notice: t('view.places.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_place_url(@place), alert: t('view.places.stale_object_error')
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :ok }
    end
  end
end
