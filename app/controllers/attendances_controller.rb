class AttendancesController < ApplicationController

  PER_PAGE = 20

  def index
    @attendances = Attendance.between_time(start_time, end_time).includes(:user).paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
  end

  private
    def start_time
      (parse_time(params[:start_time]) || Time.current).beginning_of_day
    end

    def end_time
      (parse_time(params[:end_time]) || Time.current).end_of_day
    end

    def parse_time(time)
      Date.parse(time) rescue nil
    end
end