class PermissionsController < ApplicationController

  before_action :find_permission, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @permissions = Permission.includes(:role)
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new permission_params
    if @permission.save
      redirect_to permissions_path
    else
      render :new
    end
  end

  def update
    if @permission.update_attributes permission_params
      redirect_to permissions_path
    else
      render :edit
    end
  end

  def destroy
    @permission.destroy
    redirect_to permissions_path
  end

  private
    def permission_params
      params.require(:permission).permit(:role_id, :action, :subject_class)
    end

    def find_permission
      @permission = Permission.where(:id => params[:id]).first
      unless @permission
        redirect_to permissions_path
      end
    end

end