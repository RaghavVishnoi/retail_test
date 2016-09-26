module Api
  module V1
    class ResponseController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
      require 'httparty'

       def parser
          key = params[:key]
	        response = DropdownValue.data
	        value = response[key]  
          render :json => {response: value}
       end

    end
  end
end       