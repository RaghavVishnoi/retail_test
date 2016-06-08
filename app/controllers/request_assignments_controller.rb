class RequestAssignmentsController < ApplicationController
  
  before_action :set_request_assignment, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user
  skip_before_action :verify_authenticity_token, only: [:create,:userInfo]
  respond_to :html

  PER_PAGE = 50

  def index
    @request_assignments = RequestAssignment.all.paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
    respond_with(@request_assignments)
  end

  def show
    respond_with(@request_assignment)
  end

  def new
    session[:prev_url] = request.fullpath
    @requests = RequestAssignment.unassigned_requests.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
  end

  def edit
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
    @request_assignment.update(request_assignment_params)
    respond_with(@request_assignment)
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

  private
    def set_request_assignment
      @request_assignment = RequestAssignment.find(params[:id])
    end

    def request_assignment_params
      params.require(:request_assignment).permit(:user_id,:request_id,:user_type,:assigned_by,:admin_type,:priority)
    end
end
