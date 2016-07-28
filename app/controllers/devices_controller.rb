class DevicesController < ApplicationController

	authorize_resource :only => [:create,:new]
	PER_PAGE = 50

	def index
		@devices = Device.all.paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
	end

end
