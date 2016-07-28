module Api
  module V1
    class AttendancesController < BaseController

      before_action :initialize_attendance

      def create
        @attendance.attributes = attendance_params
        if @attendance.save
          render :json => { :result => true }
        else
          render :json => { :result => false, :errors => { :messages => @attendance.errors.full_messages } }
        end
      end

      private
        def attendance_params
          params.require(:attendance).permit(:punch_in_image, :punch_in_lat, :punch_in_long, :punch_out_image, :punch_out_lat, :punch_out_long).merge(default_params)
        end

        def default_params
          if params[:punch_in] == "true"
            { :punch_in_time => @current_time, :request_in_time => @current_time, :punch_in_ip => request.ip }
          else
            { :punch_out_time => @current_time, :request_out_time => @current_time, :punch_out_ip => request.ip }
          end
        end

        def initialize_attendance
          @current_time = Time.current
          end_time = @current_time.end_of_day
          start_time = @current_time.beginning_of_day
          @attendance = current_user.attendances.between_time(start_time, end_time).first
          @attendance ||= current_user.attendances.new
        end
    end
  end
end