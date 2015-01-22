class CitiesController < ApplicationController

  def new
    @city = City.new
  end
  
  def create
    @city = City.new city_params
    if @city.save
      respond_to do |format|
        format.html { redirect_to cities_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def city_params
      params.require(:city).permit(:name)
    end
end