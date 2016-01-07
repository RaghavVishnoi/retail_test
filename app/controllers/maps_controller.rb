class MapsController < ApplicationController
before_action :find_request, :only => [:edit,:update]
	

	def index
		click = params[:commit]
		if click == '' || click == nil
		  @map = Request.all
		else
		 @map = Map.image_data(params[:request_type],params[:status],params[:state],params[:cmo],params[:from].to_s,params[:to].to_s,params[:store_size],params[:rsp_present],params[:gionee_sales])
    	end
    end

    
	    
	    

     


end
