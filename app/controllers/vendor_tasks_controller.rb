class VendorTasksController < ApplicationController
	before_action :find_request, :only => [:edit,:update]
	authorize_resource :except => [:new,:create]
    skip_before_action :authenticate_user, :only => [:create, :new]

    PER_PAGE = 10

	 def index
	 	 id = session[:user_id]
	 	 @user = User.find_by(:id => id)
         @associated_roles = AssociatedRole.find_by(:object_id => id)
         @role = @associated_roles.role  
         if @role.name == 'cmo'
	 	       @requests =  VendorTask.request_list(@user.email)
	 	     end
	 	    @vendor_task = VendorTask.with_query(params[:q]).includes(:images).order('updated_at desc').paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
	 end

	def new
    
		@vendor_task = VendorTask.new
    respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :result => false } }
    end
    
	end



	def create  
    request_id = params[:vendor_task][:request_id]
		 arr  = ["Request id is not valid"]
     if Request.where(:id => request_id).blank?
      respond_to do |format|
        format.html { redirect_to "/vendor_tasks/new", :notice => "request id is not valid" }
        format.json { render :json => { :errors => {:messages => arr } } }
      end
	 else
     
	    @vendor_task = VendorTask.new vendor_task_params

		if @vendor_task.save
			respond_to do |format|
        format.html { redirect_to new_vendor_task_path, :notice => "Your Request has been submitted" }
        format.json { render :json => { :result => true } }
      end
		else
		respond_to do |format|
        
        format.json { render :json => { :result => false, :errors => { :messages => @vendor_task.errors.full_messages } } }
        end
      end
	end
  end

  def edit
   @prev_url = request.referer
  end

  def update
   prev_url = params[:prev_url]

    id = session[:user_id]
    @user = User.find_by(:id => id)
    @associated_roles = AssociatedRole.find_by(:object_id => id)
    @role = @associated_roles.role
    comment = params[:comment]
    comment = comment.strip
    date = Time.now.to_date

    if  @role.name == 'approver' ||  @role.name == 'superadmin'  &&  params[:status] == "pending"
          date = Time.now.to_date
          @vendor_task.approver_approve_date = date
       if params[:commit] == "Approve"
          @vendor_task.approver_id = current_user.id
         if comment == ''
          @vendor_task.comment_by_approver = 'ok'
         else
          @vendor_task.comment_by_approver = comment
         end
         @vendor_task.approve
         
       elsif params[:commit] == "Decline"
         @vendor_task.approver_id = current_user.id
         if comment == ''
          @vendor_task.comment_by_approver = 'Not Suitable'
         else
          @vendor_task.comment_by_approver = comment
         end
         @vendor_task.decline
       end
       if @vendor_task.errors.present?
          render :edit
       else
      redirect_to prev_url
       end

    end

    if  @role.name == 'cmo' ||  @role.name == 'superadmin'  &&  params[:status] == "cmo_pending"
        
       @vendor_task.cmo_approve_date = date
       if params[:commit] == "Approve"
        if comment == ''
          @vendor_task.comment_by_cmo = 'ok'
        else
           @vendor_task.comment_by_cmo = comment
        end
         @vendor_task.cmo_approve
          
        elsif params[:commit] == "Decline"
         if comment == ''
           @vendor_task.comment_by_cmo = 'Not Suitable'
         else
           @vendor_task.comment_by_cmo = comment
         end
         @vendor_task.cmo_decline
       end
       if @vendor_task.errors.present?
        puts "error #{@vendor_task.errors}"
          render :edit
       else
      redirect_to prev_url
       end

    end
   
  end	

  def view
       @request=""
       role = VendorTask.user_role(session[:user_id])
       if role.name == 'cmo'
       cmo_id = VendorTask.cmo_id(session[:user_id])
       else
       cmo_id = ''
       end
       
        
      
      begin
       id = session[:requestId]
       @request_id = VendorTask.find(params[:id])
       @request = Request.find(@request_id.request_id)
       session[:requestId] = params[:id]
     if role.name == 'cmo' && cmo_id != @request.cmo_id
           redirect_to :back, :flash => { :notice => "Sorry! You can't access this request" }
     else
           
           redirect_to "/vendor_tasks/#{params[:id]}/edit"
     end 
     rescue
        flash.now[:error] = "Entered requested id does not exist"
        begin

          redirect_to :back, :flash => { :notice => "Entered request id does not exist" }
        rescue
          
        end
      end
    end

  def vendor_task_params
    params.require(:vendor_task).permit(:retailer_code,:request_id,:requestor_type,:vendor_id,:other_identity,:installation_of,:installation_report,:comment, :image_ids_string, :image_ids => [])
  end

  def find_request
    @vendor_task = VendorTask.where(:id => params[:id]).first
    unless @vendor_task
      redirect_to vendor_tasks_path
    end
  end

end
