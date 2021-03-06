class RequestAssignmentsController < ApplicationController
  
  before_action :set_request_assignment, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user
  skip_before_action :verify_authenticity_token, only: [:create,:userInfo,:mass_assignment,:update,:terminate]
  respond_to :html

  PER_PAGE = 50

  def index
    session[:prev_url] = request.fullpath
    @request_assignments = RequestAssignment.assignment(params).paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
    respond_with(@request_assignments)
  end

  def show
    respond_with(@request_assignment)
  end

  def new
    session[:prev_url] = request.fullpath
    @requests = RequestAssignment.unassigned_requests(params).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
  end

  def edit
    session[:prev_url] = request.fullpath
    @request_assignment = RequestAssignment.find(params[:id])
  end

  def create
    @request_assignment = RequestAssignment.new(request_assignment_params.
                                                  merge(assign_date: Time.now,
                                                    current_stage: 'pending',
                                                    status: 'pending')
                                                )
    if @request_assignment.save

      respond_to do |format|
        format.html
        format.json {render :json => {result: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render :json => {result: @request_assignment.errors.full_messages}}
      end
    end
   end

  def update
    @request_assignment = RequestAssignment.where(id: params[:request_assignment][:assignment_id]).update_all(user_id: params[:request_assignment][:vendor_id],priority: params[:request_assignment][:priority])
    VendorMailer.delay.vendorReplace(RequestAssignment.find(params[:request_assignment][:assignment_id]).request)
    render :json => @request_assignment
  end

  def destroy
    @request_assignment.destroy
    respond_with(@request_assignment)
  end

  def userInfo
    user_id = params[:user_id]
    data = RequestAssignment.user_info(user_id)
    render :json => {result: true,object: data}
  end

  def counts
    @counts = RequestAssignment.valc_assignment_count(params[:start_date],params[:end_date],params[:states])
    render :json => @counts
  end

  def mass_assignment
    request_assignment = RequestAssignment.mass_assignment(params[:request_assignment])
    RequestAssignment.sendNotification(params[:request_assignment])
    
    render :json => request_assignment
  end

  def approve
    request_assignment = RequestAssignment.find(params[:id]).update(:is_valc => true)
    VendorMailer.delay.vendorVerify(RequestAssignment.find(params[:id]).request)
    redirect_to new_request_assignment_path(:is_rrm => true)
  end

   

  def terminate
    result = RequestAssignment.terminateRequest(params[:requestAssignmentId])
    render :json => result
  end

  private
    def set_request_assignment
      @request_assignment = RequestAssignment.find(params[:id])
    end

    def request_assignment_params
      params.require(:request_assignment).permit(:user_id,:request_id,:user_type,:assigned_by,:admin_type,:priority)
    end
end
