module Api
  module V1
    class DocumentsController < BaseController
    	include RepositoriesHelper
		skip_authorize_resource
    	skip_before_action :authenticate_user
    	PER_PAGE = 10
    	def list
    		@document = get_document.paginate(:per_page => PER_PAGE, :page => (params[:page] || 1))
    		render :json => {:result => "success",:data => @document}
    	end
    end
   end
  end	