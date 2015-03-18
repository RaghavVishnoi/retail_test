class RegionsController < ApplicationController
  
  before_action :set_region, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @regions = Region.all
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new region_params
    if @region.save
      redirect_to regions_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @region.update_attributes region_params
      redirect_to regions_url
    else
      render :edit
    end
  end

  def destroy
    @region.destroy
    redirect_to regions_url
  end

  private
    def region_params
      params.require(:region).permit(:name, :properties => [:field_id, :value])
    end

    def set_region
      @region = Region.where(:id => params[:id]).first
      unless @region
        redirect_to regions_url, alert: "Region not found"
      end
    end
end