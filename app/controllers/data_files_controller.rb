class DataFilesController < ApplicationController
  
  before_action :initialize_data_file, :only => [:new, :create]
  before_action :find_data_file, :only => [:edit, :update, :destroy, :share, :show]
  authorize_resource :instance_name => :data_file

  def index
    @data_files = DataFile.includes(:owner, :users, :regions, :roles).with_parent_id(params[:parent_id]).accessible_by(current_user)
    respond_to do |format|
      format.html 
      format.json { render :json => { :result => true, :data_files => ActiveModel::ArraySerializer.new(@data_files, :each_serializer => DataFileSerializer) } }
    end
  end

  def new
    respond_to do |format|
      format.html
      format.json { render :json => { :result => true, :data_file => DataFileSerializer.new(@data_file, :root => false) } }
    end
  end

  def create
    @data_file.attributes = data_file_params
    if @data_file.save
      respond_to do |format|
        format.html { redirect_to data_files_path(:parent_id => @data_file.parent_id) }
        format.json { render :json => { :result => true, :data_file => DataFileSerializer.new(@data_file, :root => false) } }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :result => false, :errors => { :messages => @data_file.errors.full_messages } } }
        format.js
      end
    end
  end
  
  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { :result => true, :data_file => DataFileSerializer.new(@data_file, :root => false) } }
    end
  end

  def update
    if @data_file.update_attributes(data_file_params)
      respond_to do |format|
        format.html { redirect_to data_files_path(:parent_id => @data_file.parent_id) }
        format.json { render :json => { :result => true, :data_file => DataFileSerializer.new(@data_file, :root => false) } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render :json => { :result => false, :errors => { :messages => @data_file.errors.full_messages } } }
      end
    end
  end

  def destroy
    @data_file.destroy
    respond_to do |format|
      format.html { redirect_to data_files_path(:parent_id => @data_file.parent_id) }
      format.json { render :json => { :result => true } }
    end
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
        respond_to do |format|
          format.html { redirect_to data_files_path, :alert => "File not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["File not found"] } } }
        end
      end
    end
  
end