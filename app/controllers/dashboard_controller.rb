class DashboardController < ApplicationController
   
  def index
  	@response  = Dashboard.data(current_user,params)
  end

end