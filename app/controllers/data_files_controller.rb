class DataFilesController < ApplicationController
  
  before_action :initialize_data_file, :only => [:new, :create]
  before_action :find_data_file, :only => [:edit, :update, :destroy, :share, :show]
  authorize_resource :instance_name => :data_file

  def index
    @data_files = DataFile.with_parent_id(params[:parent_id]).accessible_by(current_ability)
  end

  def create
    @data_file.attributes = data_file_params
    if @data_file.save
      redirect_to data_files_path(:parent_id => @data_file.parent_id)
    else
      render :new
    end
  end
  
  def edit
  end

  def update
    if @data_file.update_attributes(data_file_params)
      redirect_to data_files_path(:parent_id => @data_file.parent_id)
    else
      render :edit
    end
  end

  def destroy
    @data_file.destroy
    redirect_to data_files_path(:parent_id => @data_file.parent_id)
  end

  def share
    if @data_file.sharable?
      FileMailer.delay.share_file_url(params[:email], @data_file.data_file_url) if params[:email].present?
      render :json => { :result => true }
    else
      render :json => { :result => false, :errors => { :messages => ["This file is not sharable"] } }
    end
  end

  private
    def find_data_file
      @data_file = DataFile.where(:id => params[:id]).first
      unless @data_file
        redirect_to data_files_path, :alert => "File not found"
      end
    end
  
end