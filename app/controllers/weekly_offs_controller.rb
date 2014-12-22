class WeeklyOffsController < ApplicationController
  def index
  end

  def create
    WeeklyOff.days.values.each do |day|
      if weekly_off_params.include? day.to_s
        WeeklyOff.create :day => day
      else
        WeeklyOff.where(:day => day).destroy_all
      end
    end
    redirect_to weekly_offs_url, notice: "Updated successfully"
  end
  
  private

    def weekly_off_params
      params[:days].is_a?(Array) ? params[:days] : []
    end
end