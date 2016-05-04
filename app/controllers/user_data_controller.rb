class UserDataController < ApplicationController
	
	def new
		@user_data = UserData.new
	end

	def index
		@user_data= UserData.all
	end


	def create
		@user_data = Users.new(user_data)
		# if @user_data.save
		# 	redirect_to user_data_path
		# else
		# 	render 'new'
		# end
	end

	private
		def user_data
			params.require(:user_data).permit(:name,:location,:designation,:email,:status,:phone,:user_id)
		end
end
