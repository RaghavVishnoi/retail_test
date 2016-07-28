class SchemaController < ApplicationController
  skip_before_action :authenticate_user

  def index
    schema = JSON.parse(File.read("#{Rails.root}/app/views/schema/index.json"))
    active_module_names = ModuleGroup.active(params[:app_id]).map(&:name)
    render :json => schema.values_at(*active_module_names).compact.flatten, :root => false
  end
end