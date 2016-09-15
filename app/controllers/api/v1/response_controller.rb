module Api
  module V1
    class ResponseController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
      require 'httparty'

       def parser
	        key = params[:key]
	        response = HTTParty.get('http://requesterapp.gionee.co.in/api/v1/dropdown_values')
	        json = JSON.parse(response.body)
	        value = json[key]  
          render :json => {response: value}
       end

    end
  end
end       