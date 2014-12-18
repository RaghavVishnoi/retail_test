class UsersController < ApplicationController
  before_action :set_user, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @users = User.all
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :roles => [])
    end

    def set_user
      @user = User.where(:id => params[:id]).first
      unless @user
        redirect_to users_url, alert: "User not found"
      end
    end
end