 class VendorRequestsController < ApplicationController

	before_action :set_user, :only => [:edit, :update, :destroy,:show]
  skip_before_action :authenticate_user, :only => [:create, :new]
  authorize_resource :except => [:create]
  PER_PAGE = 50


    def index
      session[:prev_url] = request.fullpath
      @vendor_requests = VendorRequest.vendor_requests(current_user).paginate(:per_page => PER_PAGE,page: (params[:page] || 1))  
    end

    
    def create
      @vendor_request = VendorRequest.new vendor_request_params
      if @vendor_request.save
        respond_to do |format|
          format.html
          format.json { render :json => {result: true,object: @vendor_request}}
        end
      else
        respond_to do |format|
          format.html 
          format.json { render :json => {result: true,message: @vendor_request.errors.full_messages}}
        end
      end
    end

    def update 
      if current_user.roles.pluck(:name).any?{|role| CMO_ROLE_AUTH.include?(role)}
      	if params[:commit] == APPROVE
           if params[:comment] == ''
            @vendor_request.cmo_comment = 'ok'
           else
            @vendor_request.cmo_comment = params[:comment]
           end
           @vendor_request.cmo_approve
        else
           if params[:comment] == ''
            @vendor_request.cmo_comment = 'Not Suitable'
           else
            @vendor_request.cmo_comment = params[:comment]
           end
           @vendor_request.cmo_decline
        end 
        @vendor_request.cmo_response_date = Time.now
        VendorRequest.add_activity(params,current_user,@vendor_request)   
      elsif current_user.roles.pluck(:name).any?{|role| RRM_ROLE_AUTH.include?(role)}
        if params[:commit] == APPROVE
           if params[:comment] == ''
            @vendor_request.rrm_comment = 'ok'
           else
            @vendor_request.rrm_comment = params[:comment]
           end
           @vendor_request.approve
        else
           if params[:comment] == ''
            @vendor_request.rrm_comment = 'Not Suitable'
           else
            @vendor_request.rrm_comment = params[:comment]
           end
           @vendor_request.decline
       end
        @vendor_request.rrm_response_date = Time.now
        VendorRequest.add_activity(params,current_user,@vendor_request)   
       else
        redirect_to :edit
      end 
      redirect_to edit_vendor_request_path
    end

    def destroy
    	 
    end

    def vendor_request_params
    	params.require(:vendor_request).permit(:request_assignment_id,:installation_of,:installation_report,:installed_on,:status,:cmo_comment,:cmo_response_date,:rrm_comment,:rrm_response_date)
    end

    def set_user
      @vendor_request = VendorRequest.where(:id => params[:id]).first
      unless @vendor_request
        redirect_to vendor_requests_url, alert: "User not found"
      end
    end

   

end
