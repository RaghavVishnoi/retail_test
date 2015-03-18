class ModuleGroupsController < ApplicationController
  
  before_action :set_module_group, :only => [:toggle_activation]

  authorize_resource

  def index
    @module_groups = ModuleGroup.all
  end

  def toggle_activation
    @module_group.toggle!(:active)
  end


  private

    def set_module_group
      @module_group = ModuleGroup.where(:id => params[:id]).first
      unless @module_group
        redirect_to module_groups_path, alert: "Module not found"
      end
    end
end