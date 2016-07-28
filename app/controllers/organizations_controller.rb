class OrganizationsController < ApplicationController
  before_action :set_organization
  authorize_resource

  def edit
  end

  def update
    if @organization.update_attributes(organization_params)
      redirect_to organization_edit_url
    else
      render :edit
    end
  end

  private
    def set_organization
      @organization = Organization.first
    end

    def organization_params
      params.require(:organization).permit(:name, :logo, :properties => [:field_id, :value, :values => []])
    end
end