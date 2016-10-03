class SessionsController < ApplicationController
  
  skip_before_action :authenticate_user, :except => [:destroy]
   
  
  layout 'signin'

  def new
  end

  def create
    @user = User.with_password.with_email(params[:email]).first if params[:email]
    if @user && @user.authenticate(params[:password]) 
      sign_in @user
      redirect_to dashboard_path
    else
      redirect_to users_sign_in_path, alert: "Invalid email or password"
    end
  end

  def destroy
    sign_out
    redirect_to users_sign_in_path, notice: "You have been signed out successfully"
  end
end