module Api
  module Gpulse
    class StatelistsController < BaseController
      skip_before_action :verify_authenticity_token
      
        def index
            @state = Retailer.all.pluck(:state).uniq
			render :json => {:result => true,:state => @state}
    	end
     end
 end
end
