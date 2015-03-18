class UsersReportingsController < ApplicationController

  def index
    @users = current_user.reporting_users
  end
  
  def autocomplete
    users = current_user.reporting_users.with_name(params[:q]).pluck(:name, :id)
    render :json => users, root: false
  end
end