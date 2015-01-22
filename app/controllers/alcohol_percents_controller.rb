class AlcoholPercentsController < ApplicationController

  def new
    @alcohol_percent = AlcoholPercent.new
  end
  
  def create
    @alcohol_percent = AlcoholPercent.new alcohol_percent_params
    if @alcohol_percent.save
      respond_to do |format|
        format.html { redirect_to alcohol_percents_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def alcohol_percent_params
      params.require(:alcohol_percent).permit(:value)
    end
end