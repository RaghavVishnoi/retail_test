class UsersController < ApplicationController
  before_action :set_user, :only => [:edit, :update, :destroy]

  def index
    @users = User.all
  end
  
  def autocomplete
    @users = User.with_name(params[:q]).pluck(:name, :id)
    render :json => @users, root: false
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      redirect_to [:edit, @user], notice: "Updated successfully"
    else
      render :edit
    end
  end

  def create
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
      if current_user.superadmin?
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :department_ids, :roles => [], :region_ids => [], :business_unit_ids => [], :job_title_ids => [], :weekly_off_ids => []).merge(:skip_password_validation => true)
      else
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end

    def set_user
      @user = User.where(:id => params[:id]).first
      unless @user
        redirect_to users_url, alert: "User not found"
      end
    end
end