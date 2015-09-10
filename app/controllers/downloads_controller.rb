class DownloadsController < ApplicationController
	before_action :find_file, :only => [:show]

	def index
	end

	def create
		RequestsCsv.new(params[:from_date].to_s, params[:till_date].to_s,params[:request_type]).delay.generate
	    redirect_to downloads_path, :notice => "link send to your email"
    end

    def find_file
      @file_path = RequestsCsv.absolute_file_path(params[:file_name])
      unless File.exists? @file_path
        redirect_to root_path, :alert => "File does not exist"
      end
    end

end
