module Api
  module V1
    class TestController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        
      

      def index
        self.class.test_val = request.query_parameters if request.query_parameters.present?
        render :json => self.class.test_val
      end

      
    end
  end
end