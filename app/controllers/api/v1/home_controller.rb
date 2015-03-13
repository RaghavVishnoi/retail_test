module Api
  module V1
    class HomeController < BaseController
      skip_authorize_resource

      def index
        render :json => { :result => true, :email => current_user.email, :personalized_message => current_user.personalized_message, :attendance_status => current_user.attendance.status }
      end
    end
  end
end