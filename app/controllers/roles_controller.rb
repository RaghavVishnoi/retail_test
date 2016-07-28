class RolesController < ApplicationController

  PER_PAGE = 20
  before_action :find_role, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @roles = Role.all.paginate(:per_page => PER_PAGE,:page => (params[:page] || 1))
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new role_params
    if @role.save
      redirect_to roles_path
    else
      render :new
    end
  end

  def update
    if @role.update_attributes role_params
      redirect_to roles_path
    else
      render :edit
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_path
  end

  private
    def role_params
      params.require(:role).permit(:name)
    end

    def find_role
      @role = Role.where(:id => params[:id]).first
      unless @role
        redirect_to roles_path
      end
    end

end