class ServicesController < ApplicationController

	def index
		stdout, stdeerr, status = Open3.capture3("RAILS_ENV=development ./script/delayed_job status")
		render :json => {result: stdout}
	end

end