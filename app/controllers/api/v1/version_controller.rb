module Api
  module V1
  	class VersionController < BaseController

  		skip_authorize_resource
  		skip_before_action :authenticate_user 

  		def index
  			@version = VERSION
  			render :json => {result: true,version: @version}
  		end

  	end
  end
end