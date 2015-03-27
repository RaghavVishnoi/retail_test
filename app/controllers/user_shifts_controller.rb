class UserShiftsController < ApplicationController
  PER_PAGE = 20

  before_action :set_user, :only => [:update]

  def index
    @users = User.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
  end

  def update
    @user.update_attributes(user_shift_params)
  end

  def update_all
    @users = params[:user_ids].present? ? User.where(:id => params[:user_ids]) : []
    @users.each do |user|
      user.update_attributes(:shift_start_time => params[:shift_start_time], :shift_end_time => params[:shift_end_time], :timezone => params[:timezone])
    end
    redirect_to user_shifts_path
  end

  private
    def user_shift_params
      params.require(:user).permit(:shift_start_time, :shift_end_time, :timezone)
    end

    def set_user
      unless @user = User.where(:id => params[:id]).first
        render
      end
    end
end