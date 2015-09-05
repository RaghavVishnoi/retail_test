class MapsController < ApplicationController
before_action :find_request, :only => [:edit,:update]
	

	def index
		click = params[:commit]
		if click == '' || click == nil
		  @map = Request.all
		else
		 
		  @status = params[:status],@state = params[:state],@cmo = params[:cmo],@from = params[:from],@to = params[:to],@rsp_present = params[:rsp_present],@gionee_sales = params[:gionee_sales],@request_type = params[:request_type],@store_size = params[:store_size]
		  @map = Map.image_data(params[:request_type],params[:status],params[:state],params[:cmo],params[:from].to_s,params[:to].to_s,params[:store_size],params[:rsp_present],params[:gionee_sales])
    	end
    end

    
	    
	    

     


end
