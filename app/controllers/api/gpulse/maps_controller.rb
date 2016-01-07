module Api
  module Gpulse
    class MapsController < BaseController
      skip_before_action :verify_authenticity_token
      PER_PAGE = 1000
        def index
            @map = Map.image_data(params[:request_type],params[:status],params[:state],params[:cmo],params[:from].to_s,params[:to].to_s,params[:store_size],params[:rsp_present],params[:gionee_sales]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
            requests = []
            @map.each do |map|
            	images = {}
 				id = map.id
                images.merge!(:image => Image.where(:imageable_id => id).pluck(:lat,:long))
            	images.merge!(:request => request_data(map))
                images.merge!(:cmo => cmo_data(map.cmo_id))
                images.merge!(:retailer => retailer_data(map.retailer_code))
            	requests.push(images)
            end
            render :json => {:result => true,:map => requests}
    	end

    	def request_data(req)
    		request = {} 
    		request.merge!(:id => req.id)  
    		request.merge!(:retailer_code => req.retailer_code)  
    		request.merge!(:request_type => req.request_type)  
    		request.merge!(:state => req.state)
    		request.merge!(:city => req.city)
    		request.merge!(:status => req.status)   
    		request          	
    	end

    	def request_type(type)
    	 case type
    	 when 0
    	 	'GSB'
    	 when 1
    	 	'SIS'
    	 when 2
    	 	'Inshop'
    	 when 3
    	 	'Maintenance'
    	 when 4
    	 	'Audit'
    	 end
    	end

    	def cmo_data(cmo_id)
    		@cmo = CMO.find(cmo_id)
    		cmo = {}
    		cmo.merge!(:id => @cmo.id)
    		cmo.merge!(:name => @cmo.name)
    		cmo
    	end 

    	def retailer_data(retailer_code)
    		@retailer = Retailer.find_by(:retailer_code => retailer_code)
    		retailer = {}
    		retailer.merge!(:id => @retailer.id)
    		retailer.merge!(:name => @retailer.retailer_name)
    		retailer
    	end
    end
 end
end
