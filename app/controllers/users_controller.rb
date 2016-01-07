class UsersController < ApplicationController
  before_action :set_user, :only => [:edit, :update, :destroy]
  skip_before_action :authenticate_user, :only => [:create, :new]
  
  def index
     if params[:commit] == 'Get Users'
      if params[:All] == '[cmo,vendor,requester]' 
        @participants = ['All']
        role = ['cmo','vendor','requester']
      else
        @participants = [params[:CMO],params[:Vendor],params[:Requester]].compact
        role = [params[:CMO],params[:Vendor],params[:Requester]].compact
      end
        
        @users = User.find_users(role)
         
     else 
     @participants = ['All']
     @role = User.user_role(session[:user_id])
     if params[:param] == nil
      if @role.name == 'superadmin'
        @users = User.all
      else
        @users  = User.approver_users(@role)
         
      end
    else
       @users = User.search(params[:param],@role)
        
       if @users == '' || @users == nil
        redirect_to users_path,:notice => "No user found"
      else
        @search = params[:param]
       
       end
    end
   end
  end
  
  def autocomplete
    @users = User.with_name(params[:q]).pluck(:name, :id)
    render :json => @users, root: false
  end

  def new
    @role = User.user_role(session[:user_id])
    @user = User.new
  end



  def edit
    @role = User.user_role(session[:user_id])
  end

  def update
    @role = User.user_role(session[:user_id])
    if @user.update_attributes user_params
      redirect_to [:edit, @user], notice: "Updated successfully"
    else
      render :edit
    end
  end

  def create
     @role = User.user_role(session[:user_id])
     @user = User.new user_params
    if @user.save
      redirect_to users_path, notice: "User created successfully"
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  private
    def user_params
      if current_ability.can? :create, User
        params.require(:user).permit(:name, :email, :password, :password_confirmation,:state, :department_ids, {:role_ids => []},:status, :region_ids => [], :business_unit_ids => [], :job_title_ids => [], :weekly_off_ids => []).merge(:skip_password_validation => true)
      else
        params.require(:user).permit(:name, :email,:status, :password, :password_confirmation,:state)
      end
    end

    def set_user
      @user = User.where(:id => params[:id]).first
      unless @user
        redirect_to users_url, alert: "User not found"
      end
    end
end