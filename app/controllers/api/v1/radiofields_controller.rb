module Api
  module V1
    class RadiofieldsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        def index
    		 
    		field = Field.where(:display_name => 'Store Selling Gionee').first 
    		render :json => field
    	end
     end
 end
end
