module Api
  module V1
    class TestController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user

      def index
        render :json => request.query_parameters
      end
    end
  end
end