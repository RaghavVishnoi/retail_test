class RequestsController < ApplicationController
  
  skip_before_action :authenticate_user

  def new
    @request = Request.new
    respond_to do |format|
      format.json { render :json => @request.as_json(:methods => :properties) }
    end
  end

  def create
    @request = Request.new request_params
    if @request.save
      render :json => { :result => true }
    else
      render :json => { :result => false, :errors => { :messages => @request.errors.full_messages } }
    end
  end

  def request_params
    params.require(:request).permit(:retailer_code, :rsp_name, :rsp_mobile_number, :rsp_app_user_id, :state, :city, :shop_name, :shop_address, :shop_owner_name, :shop_owner_phone, :is_main_signage, :is_sis_installed, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :width, :height, :cmo_name, :request_type, :remarks, :image_ids => [], :properties => [:field_id, :value])
  end
end