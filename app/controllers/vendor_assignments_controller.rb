class VendorAssignmentsController < ApplicationController

	skip_before_action :authenticate_user, :only => [:status]
	PER_PAGE = 10

	def index
      session[:prev_url] = request.fullpath
      @assignments = VendorAssignment.request_assignments(params,current_user).paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
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
        @stage = VendorAssignment.update_status(params)
        if @stage.save
            respond_to do |format|
              format.html {redirect_to session[:prev_url]}
              format.json {render :json => {result: true}}
            end           
        else
            redirect_to session[:prev_url],notice: @stage.errors.full_messages
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
