class SchemaController < ApplicationController
  skip_before_action :authenticate_user
  skip_authorize_resource

  def index
    schema = JSON.parse(File.read("#{Rails.root}/app/views/schema/index.json"))
    active_module_names = ModuleGroup.active.map(&:name)
    render :json => schema.values_at(*active_module_names).compact.flatten, :root => false
  end
end