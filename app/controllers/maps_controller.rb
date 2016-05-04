class MapsController < ApplicationController
before_action :find_request, :only => [:edit,:update]
skip_before_action :verify_authenticity_token


	def map_data
 
		session[:prev_url] = request.fullpath.split('map_data')[0]
     	@map = Map.image_data(params)
    	render :json => @map
 
    end

end
