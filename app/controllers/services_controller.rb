class ServicesController < ApplicationController

	def status
		stdout, stdeerr, status = Open3.capture3("RAILS_ENV=statging ./script/delayed_job status")
		render :json => {result: status}
	end

	def start
		stdout, stdeerr, status = Open3.capture3("RAILS_ENV=statging ./script/delayed_job start")
		render :json => {result: status}
	end

end