module Api
	module Gquestion
		class RetailersController < ApplicationController
			skip_before_action :verify_authenticity_token

			def index
				@result = Retailer.where(updated_at: Time.parse(params[:start_date]).to_date.beginning_of_day..Time.parse(params[:end_date]).to_date.end_of_day)
				render :json => {result: true,count: @result.length,object: @result}
			end

			def update_retailer
	          Retailer.retailer_list	
	          render :json => {result: true}
        	end

		end
	end
end