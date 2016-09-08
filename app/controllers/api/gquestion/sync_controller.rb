module Api
	module Gquestion
		class SyncController < ApplicationController
			include RetailersHelper

			def index
			  	start_date = Time.parse(params[:start_date]).to_date.strftime("%Y-%m-%d")
			  	end_date = Time.parse(params[:end_date]).to_date.strftime("%Y-%m-%d")
			  	count = zedsales_upload(start_date,end_date)
				render :json => Integer(count)
			end

		end
	end
end