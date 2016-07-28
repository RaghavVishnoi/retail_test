module Api
  module V1
    class StatelistsController < BaseController
      skip_before_action :verify_authenticity_token
      
        def index
            @state = State.all.pluck(:id,:name)
			render :json => {:result => true,:state => @state}
    	end
     end
 end
end
