module Api
  module Gpulse
    class CmosController < BaseController
    	skip_before_action :verify_authenticity_token
    	def index
    		@cmo = CMO.all.pluck(:id,:name,:location,:designation,:status)
    		render :json => {:result => true,:cmo => @cmo}
    	end


    end
  end
end