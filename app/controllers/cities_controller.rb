class CitiesController < ApplicationController

  PER_PAGE = 20

  before_action :set_city, :only => [:edit, :update, :destroy]

  def index
    @cities = City.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :per_page => @cities.per_page, :length => @cities.length, :current_page => @cities.current_page, :total_pages => @cities.total_pages, :cities => @cities.as_json }
      }
    end
  end

  def new
    @city = City.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :city => @city.as_json }
      }
    end
  end
  
  def create
    @city = City.new city_params
    if @city.save
      respond_to do |format|
        format.html { redirect_to cities_path }
        format.js
        format.json { 
          render :json => { result: true, :city => @city.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @city.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :city => @city.as_json } }
    end
  end

  def update
    if @city.update_attributes city_params
      respond_to do |format|
        format.html { redirect_to cities_path }
        format.json {
          render :json => { result: true, :city => @city.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @city.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @city.destroy
      respond_to do |format|
        format.html { redirect_to cities_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to cities_path, :alert => @city.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @city.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def city_params
      params.require(:city).permit(:name)
    end

    def set_city
      @city = City.where(:id => params[:id]).first
      unless @city
        respond_to do |format|
          format.html { redirect_to cities_path, :alert => "City not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["City not found"] } } }
        end
      end
    end
end