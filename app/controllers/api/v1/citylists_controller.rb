module Api
  module V1
    class CitylistsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        def index
    		value = params[:value]
        var1 = '{'
        var2 = '}'

             
            arr = [:city => '*Select City']
            @city = arr+Retailer.where(state: value).select(:city).uniq.order("city asc")

            render :json => @city
    	end
     end
 end
end
