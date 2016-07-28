module Api
  module V1
    class DevicesController < BaseController
    	skip_authorize_resource
    	skip_before_action :authenticate_user


    	def registration
    		@device = Device.new(:device_holder_email => params[:device_holder_email],:device_holder_state => params[:device_holder_state],:device_name => params[:device_name],:device_imei => params[:device_imei],:device_registration_id => params[:device_registration_id],:device_registration_date => Time.now,:app_id => params[:app_id],:status => params[:status])
    		if @device.save
    			render :json => {:result => 'successfully saved'}
    		else
    			render :json => {:result => 'internal server error'}
    		end	
    	end

        def update
            @device = Device.find(:imei => params[:imei])
            if @device != nil
                @device.email = params[:email]
                @device.save
            end
        end

        def destroy
            @device = Device.where(:email => params[:email],:imei => params[:imei]).destroy_all

        end


    end
  end
end