class UsersController < ApplicationController
  before_action :set_user, :only => [:edit, :update, :destroy,:show]
  skip_before_action :authenticate_user, :only => [:create, :new]
  authorize_resource
  PER_PAGE = 20

  def index
    @users = User.list_users(params,current_user).paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
    @search = params[:search].split(',') if params[:search].present?
  end
  
  def autocomplete
    @users = User.with_name(params[:q]).pluck(:name, :id)
    render :json => @users, root: false
  end

  def new
    @role = User.user_role(current_user.id)
    @user = User.new
  end

  def edit
    @role = User.user_role(current_user.id)
  end

  def show
    @user = User.find(params[:id])

  end

  def update
    @role = User.user_role(current_user.id)
    if @user.update_attributes user_params
      redirect_to users_path, notice: "Record updated successfully"
    else
      render :edit
    end
  end

  
  def create
     @role = User.user_role(current_user.id)
     @user = User.new user_params
    if @user.save
      redirect_to users_path, notice: "User created successfully"
    else
      render :edit
    end
  end

  def update
    @role = User.user_role(current_user.id)
    if @user.update_attributes user_params
      redirect_to users_path, notice: "Record updated successfully"
    else
      render :edit
    end
  end


  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  def change_status
       user = User.where(id: params[:id])
       user_data = UserData.where(user_id: params[:id])
       case user.first.status
          when 'Active'
            user.update_all(status: 'Inactive')
            user_data.update_all(status: 'Inactive') if user_data != nil
          when 'Inactive'
            user.update_all(status: 'Active')
            user_data.update_all(status: 'Active') if user_data != nil
        end
        redirect_to '/users'
    end

  def change_password    
    @user = User.find_by(reset_password_token: params[:users_reset_password_path][:token])    
     
      if @user.update(:password => params[:users_reset_password_path][:password],:password_confirmation => params[:users_reset_password_path][:password_confirmation])  
        flash[:notice] = "password successfully updated"
        redirect_to users_path
      else
         @token = @user.reset_password_token 
         render  users_reset_password_path
      end
  end

  def reset_password
    @user = User.new
  end

  private
    def user_params
      if current_ability.can? :create, User
        params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation,{:state_ids => []},:supervisor_id, :department_ids,:status,{:role_ids => []}, :region_ids => [], :business_unit_ids => [], :job_title_ids => [], :weekly_off_ids => []).merge(:skip_password_validation => true)
      else
        params.require(:user).permit(:name,  :phone,:email,:status, :password, :password_confirmation,:state)
      end
    end

    def set_user
      @user = User.where(:id => params[:id]).first
      unless @user
        redirect_to users_url, alert: "User not found"
      end
    end
end