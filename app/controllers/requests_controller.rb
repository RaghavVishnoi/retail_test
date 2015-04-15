class RequestsController < ApplicationController
  
  before_action :find_request, :only => [:edit, :update]
  authorize_resource :except => [:create, :new, :autocomplete_retailer_code]
  skip_before_action :authenticate_user, :only => [:create, :new, :autocomplete_retailer_code]

  PER_PAGE = 20

  def index
    @requests = Request.with_query(params[:q]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
  end

  def new
    @request = Request.new
    respond_to do |format|
      format.html
      format.json { render :json => @request.as_json(:methods => [:shop_requirements, :branding_details]) }
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


  def update
    if params[:commit] == "Approve"
      @request.approved_by_user_id = current_user.id
      @request.approve
    elsif params[:commit] == "Decline"
      @request.declined_by_user_id = current_user.id
      @request.decline
    end
    if @request.errors.present?
      render :edit
    else
      redirect_to requests_path
    end
  end

  def autocomplete_retailer_code
    @requests = Request.select(:retailer_code).paginate(:per_page => 100, :page => (params[:page] || '1')).uniq
    @retailer_codes = @requests.map { |r| { :display_name => r.retailer_code } }
    render :json => { :result => true, :per_page => @requests.per_page, :length => @requests.length, :current_page => @requests.current_page, :total_pages => @requests.total_pages, :retailer_codes => @retailer_codes }
  end

  private

  def request_params
    params.require(:request).permit(:retailer_code, :rsp_name, :rsp_mobile_number, :rsp_app_user_id, :state, :city, :shop_name, :shop_address, :shop_owner_name, :shop_owner_phone, :is_main_signage, :is_sis_installed, :avg_store_monthly_sales, :avg_gionee_monthly_sales, :width, :height, :cmo_name, :request_type, :remarks, :space_available, :is_gionee_gsb_present, :image_ids_string, :image_ids => [], :properties => [:field_id, :value])
  end

  def find_request
    @request = Request.where(:id => params[:id]).first
    unless @request
      redirect_to requests_path
    end
  end
end