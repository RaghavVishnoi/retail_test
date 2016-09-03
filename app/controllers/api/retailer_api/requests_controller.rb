module Api
	module RetailerApi
		class RequestsController < ApplicationController

			def index
				begin
					if params[:retailer_code] != nil
						if Request.exists?(retailer_code: params[:retailer_code])
							@requests = Request.where(retailer_code: params[:retailer_code]).order('created_at')
						else
							render :json => {result: false,status: 404,message: 'Record not found!'}
						end
					else
						render :json => {result: false,status: 422,message: 'Wrong input parameters!'}
					end
				rescue => ex
					render :json => {result: false,status: 500,message: 'Something went wrong!'}
				end
			end

		end
	end
end