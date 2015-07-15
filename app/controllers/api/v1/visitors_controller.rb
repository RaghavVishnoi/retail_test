module Api
  module V1
    class VisitorsController < BaseController
      skip_authorize_resource
      skip_before_action :authenticate_user
        def index
    		 
        	@issue = Request::TYPE_OF_ISSUE
        	render :json => @issue
             
             
    	end
     end
 end
end
