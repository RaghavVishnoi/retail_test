class HolidaysController < ApplicationController

  before_action :set_holiday, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    @holidays = Holiday.all
  end

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new holiday_params
    if @holiday.save
      redirect_to holidays_path
    else
      render :new
    end
  end

  def update
    if @holiday.update_attributes holiday_params
      redirect_to holidays_path
    else
      render :edit
    end
  end

  def destroy
    @holiday.destroy
    redirect_to holidays_path
  end

  private
    def holiday_params
      params.require(:holiday).permit(:description, :date, :timezone)
    end

    def set_holiday
      @holiday = Holiday.where(:id => params[:id]).first
      unless @holiday
        redirect_to holidays_path
      end
    end
end