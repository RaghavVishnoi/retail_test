module Api
  module V1
    class RetailerlistsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        def index

          value = params[:value]
          arr = [:retailer_code => '*Select Retailer Code']
          @city = arr+Retailer.where(city: value,status: 'Active').select(:retailer_code,:retailer_name).order("lfr_chain desc,retailer_name asc")
          render :json => @city
        end


        def retailers
          retailer_code = params[:retailer_code]
          @retailers  = Retailer.find_by(:retailer_code => retailer_code)
          if @retailers != nil && @retailers != '' 
             render :json => {:result => true, :retailers => @retailers}
          else
             render :json => {:result => false, :message => 'Retailer code not exist'}
          end
        end
  end
 end
end
