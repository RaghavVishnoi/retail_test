class VendorAssignmentsController < ApplicationController

	skip_before_action :authenticate_user, :only => [:status]
	PER_PAGE = 10

	def index
      session[:prev_url] = request.fullpath
      if params["format"] == "xls"
        @assignments = VendorAssignment.request_assignments(params,current_user)
      else
        @assignments = VendorAssignment.request_assignments(params,current_user).paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
      end
      respond_to do |format|
        format.html
        format.xls
      end
	end

	def edit
      @assignment = vendor_assignment.update(current_stage: params[:status].capitalize)
      if @assignment
        VendorStage.create!(stage_name: params[:status],request_assignment_id: params[:id],update_date: Time.now)
        redirect_to session[:prev_url]  
      else
        redirect_to session[:prev_url]  
      end
    end


    def status
      
      if INITIAL_STATUS.include?(params[:status])
        result = VendorAssignment.updateStatus(params)
        if result == 3
          VendorAssignment.notifyUsers(params)
          respond_to do |format|
            format.html {redirect_to session[:prev_url],notice: "Successfully accepted!"}
            format.json {render :json => {result: true,message: 'Status successfully updated!'}}
          end
           
        else
          redirect_to session[:prev_url],notice: DATE_ERRORS[result]
        end
      else
        result = VendorAssignment.isValidDate?(params)
        if result == 3
          VendorAssignment.notifyUsers(params)
          render :json => {result: true,message: 'Status successfully updated!'}
        else
          render :json => {result: false,message: DATE_ERRORS[result]}
        end
      end
    end

    def show
        @assignment = vendor_assignment
    end

    def po_update
      assignment = RequestAssignment.find(params[:id])
      result = assignment.update(po_number: params[:po_number])
      render :json => result
    end

    private
        def vendor_assignment
            RequestAssignment.find(params[:id])
        end


end
