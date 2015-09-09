class PasswordsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :find_user_by_reset_password_token, :only => [:edit, :update]
  before_action :find_user_by_email, :only => [:create]

  def create
    if @user
      @user.set_reset_password_token
      @user.save
      UserMailer.delay.reset_password_token(@user.email, @user.reset_password_token)
    end
    respond_to do |format|
      format.html { redirect_to passwords_new_path, notice: "Reset Password Link sent to your email." }
      format.json { render json: { result: true } }
    end
  end 

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.password_required = true
    if @user.save
      respond_to do |format|
        format.html do 
          sign_in @user
          redirect_to '/users/sign_out', notice: "Password updated successfully"
        end
        format.json { render :json => { :result => true } }
      end
    else
      respond_to do |format|
        format.html { render :edit, alert: @user.errors.full_messages.to_sentence }
        format.json { render :json => { :result => false, :errors => { :messages => @user.errors.full_messages } } }
      end
    end
  end

  private
    def find_user_by_reset_password_token
      @user = User.where(:reset_password_token => params[:token]).first if params[:token]
      unless @user
        respond_to do |format|
          format.html { redirect_to users_sign_in_url, alert: "Password token is invalid" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Password token is invalid"] } } }
        end
      end
    end

    def find_user_by_email
      if params[:email].present?
        @user = User.where(:email => params[:email]).first
      else
        respond_to do |format|
          format.html { redirect_to passwords_new_path, alert: "Email can't be blank" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Email can't be blank"] } } }
        end
      end
    end
end