module Api
  module V1
    class RetailerlistsController < BaseController
    	skip_authorize_resource
      skip_before_action :authenticate_user
        def index
    		value = params[:value]
        arr = [:retailer_code => '*Select Retailer Code']

			  @city = arr+Retailer.where(city: value,status: 'Active').select(:retailer_code,:retailer_name).order("lfr_chain desc")

        render :json => @city
    	end
     end
 end
end
