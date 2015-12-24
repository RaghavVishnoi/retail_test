class DownloadsController < ApplicationController
	before_action :find_file, :only => [:show]
  skip_before_action :verify_authenticity_token
  def index
	end

	def create
		RequestsCsv.new(params[:from_date].to_s, params[:till_date].to_s,params[:request_type],session[:user_id]).delay.generate
	   render :json => {:result => "CSV link send to your mail"}
  end

    def find_file
      @file_path = RequestsCsv.absolute_file_path(params[:file_name])
      unless File.exists? @file_path
        redirect_to root_path, :alert => "File does not exist"
      end
    end

end
