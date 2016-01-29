module Api
  module V1
    class RetailerlistsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        def index
          value = params[:value]
          arr = [:retailer_code => '*Select Retailer Code']
          @city = arr+Retailer.where(city: [value,'undefined'],status: 'Active').select(:retailer_code,:retailer_name).order("lfr_chain desc,retailer_name asc")
          render :json => @city
        end


        def retailers
          retailer_code = params[:retailer_code]
          @retailers  = Retailer.find_by(:retailer_code => retailer_code,:status => 'Active')
          if @retailers != nil && @retailers != '' 
             render :json => {:result => true, :retailers => @retailers}
          else
             render :json => {:result => false, :message => 'Retailer code not exist'}
          end
        end

        def search_retailer
          retailer_code = params[:retailer_code]
          retailer = Retailer.where("retailer_code LIKE ? AND status = 'Active'","%#{retailer_code}%")
          if retailer_list.size != 0
            render :json => {:result => true, :retailer_list => retailer_list}
          else
            render :json => {:result => false, :retailer_list => "No retailer code match"}
          end
        end
  end
 end
end
