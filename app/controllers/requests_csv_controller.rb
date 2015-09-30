class RequestsCsvController < ApplicationController
  before_action :find_file, :only => [:show]

  def create
    RequestsCsv.new(params[:start_date].to_s, params[:end_date].to_s,'',session[:user_id]).delay.generate
    respond_to do |format|
      format.js
    end
  end

  def show
    send_file @file_path, :x_sendfile => true
  end

  private

    def find_file
      @file_path = RequestsCsv.absolute_file_path(params[:file_name])
      unless File.exists? @file_path
        redirect_to root_path, :alert => "File does not exist"
      end
    end
end