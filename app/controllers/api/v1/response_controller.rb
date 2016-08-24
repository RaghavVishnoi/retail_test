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
          my_logger ||= Logger.new("#{Rails.root}/log/user.log")
          my_logger.info "Accessed in new app"    
          render :json => {response: value}
       end

    end
  end
end       