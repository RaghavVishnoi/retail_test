class PasswordsController < ApplicationController
  before_action :set_user, :only => [:update]

  def edit
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      redirect_to [:edit, @user], notice: "Password updated successfully"
    else
      render :edit, alert: @user.errors.full_messages.to_sentence
    end
  end

  private
    def set_user
      @user = User.where(:reset_password_token => params[:token]).first if params[:token]
      unless @user
        redirect_to :back, alert: ["Password token is invalid"]
      end
    end
end