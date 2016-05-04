 class VendorRequestsController < ApplicationController

	before_action :set_user, :only => [:edit, :update, :destroy]
  skip_before_action :authenticate_user, :only => [:create, :new]
  authorize_resource
  PER_PAGE = 50


  def index
      if params[:param] == '' || params[:param] == nil
         @vendor_request = VendorRequest.all.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
         if @vendor_request == nil
               redirect_to new_vendor_request_path, :notice => "No record found"
        end
      else
            
          @vendor_request = VendorRequest.search(params[:type],params[:param]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
		      puts "here is vendor request #{@vendor_request}"
          if @vendor_request == nil || @vendor_request == ''
                redirect_to new_vendor_request_path, :notice => "No record found"
          end
      end
    end

    def new
      @vendor_request = VendorRequest.new
      @vrequests = VendorRequest.where('status != ?','declined').pluck(:request_id)
      @requests = VendorRequest.assignments(@vrequests,params[:type]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
    end

    def create
        @redirected_url = request.referer
        
         if @redirected_url.include? "/requests/"   
               @vendor_request = VendorRequest.new vendor_request_param
            if @vendor_request.save 
               path = @redirected_url.split("&alert")[0]
               redirect_to path
                
            else
                redirect_to request.referer, notice: "Try again with right vendor"
            end 
         else
            if params[:vendor_request][:request_id].include? ","
               
               @request_id = params[:vendor_request][:request_id].split(",")  
                 
                 @request_id.each do |request_id|
                    @vendor_request = VendorRequest.array_insert(request_id,params[:vendor_request][:vendor_id],params[:vendor_request][:vendor_response],params[:vendor_request][:vendor_response_date],params[:vendor_request][:assigned_date],params[:vendor_request][:status])
                 end
                    vendor_email = VendorRequest.vendor_email(params[:vendor_request][:vendor_id]) 
                    VendorMailer.delay.vendor_assignment(vendor_email,@request_id)
                    redirect_to vendor_requests_path, notice: "Request assigned successfully!"
            else
                    @vendor_request = VendorRequest.new vendor_request_param
                    if @vendor_request.save
                       vendor_email = VendorRequest.vendor_email(params[:vendor_request][:vendor_id]) 
                       VendorMailer.delay.vendor_assignment(vendor_email,@vendor_request.request_id)
                       redirect_to vendor_requests_path, notice: "Request assigned successfully"
                       
                    else
                        redirect_to new_vendor_request_path, notice: "Some fields are required"
                    end 
            end
         end
    end

    def show
        @vendor_request = VendorRequest.find(params[:id])
    end

    def update 
    	if @vendor_request.update_attributes vendor_request_param
    	  redirect_to vendor_requests_path, notice: "Request updated successfully"
	    else
	      redirect_to :edit		
	    end
    end

    def destroy
    	@vendor_request.destroy
      redirect_to vendor_requests_path, notice: "Request unassign successfully"
    end

    def vendor_request_param
    	params.require(:vendor_request).permit(:request_id,:vendor_id,:vendor_response,:vendor_response_date,:assigned_date,:status)
    end

    def set_user
      @vendor_request = VendorRequest.where(:id => params[:id]).first
      unless @vendor_request
        redirect_to vendor_requests_url, alert: "User not found"
      end
    end

    def list

    end

end
