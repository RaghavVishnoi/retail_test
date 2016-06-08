class DashboardController < ApplicationController
  
  def index
  	session[:prev_url] = request.fullpath
  	@response  = Dashboard.data(current_user,params)
  end

end