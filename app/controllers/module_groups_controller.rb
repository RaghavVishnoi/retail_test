class ModuleGroupsController < ApplicationController
  
  before_action :set_module_group, :only => [:edit, :update]

  authorize_resource

  def index
    @module_groups = ModuleGroup.all
  end

  def update
    if @module_group.update_attributes module_group_params
      redirect_to module_groups_path
    else
      render :edit
    end
  end

  private

    def module_group_params
      params.require(:module_group).permit(:app_ids => [])
    end

    def set_module_group
      @module_group = ModuleGroup.where(:id => params[:id]).first
      unless @module_group
        redirect_to module_groups_path, alert: "Module not found"
      end
    end
end