class VendorAssignmentsController < ApplicationController

	skip_before_action :authenticate_user, :only => [:status]
	PER_PAGE = 10

	def index
		if params[:param] == nil || params[:param] == ''
			@assignments = VendorAssignment.assignments(session[:user_id],params[:q][:status]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
		else
		 	@search = params[:param]
		    @assignments = VendorAssignment.get_search_result(params[:param],params[:q][:status],session[:user_id])		
		      
          if @assignments == nil || @assignments == ''
		  	@assignments = VendorAssignment.assignments(session[:user_id],params[:q][:status]).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
		    redirect_to vendor_assignments_path(:q => {:status => params[:q][:status]}), :notice => 'No record found'
		  end 	
		end  
	end

	def edit
        id = params[:id].split('/')
        VendorAssignment.update_status(id,params[:status])
		redirect_to vendor_assignments_path(:q => {:status => 'waiting'})
	end


    def status
        @assignment = VendorAssignment.find(params[:id])
        @average = 0;

        case @assignment.vendor_response
        when 'Accepted'	
        	@average = 12;
        when 'ShopVisit'
        	@average = 24;
        when 'EstimateShared'	
        	@average = 36;
        when 'PoReceived'	
        	@average = 48;
        when 'InProduction'	
        	@average = 60;
        when 'InTransit'	
        	@average = 72;
        when 'InstallationComplete'	
        	@average = 84;
        when 'BillReceived'	
        	@average = 99;
        end
    end

    def show
    	if params[:id] != nil && params[:id] != '' && params[:id] != 'status' 
    	   @assignment = VendorAssignment.find(params[:id])
    	else
    	   url = request.original_url
    	   puts "here is url #{url}"
    	   id = url.split('=')[1]
    	   redirect_to vendor_assignment_path(id)
        end
    end


end
