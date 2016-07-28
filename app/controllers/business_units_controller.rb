class BusinessUnitsController < ApplicationController
  
  before_action :set_business_unit, :only => [:edit, :update, :destroy]
  
  authorize_resource

  def index
    @business_units = BusinessUnit.all
  end

  def new
    @business_unit = BusinessUnit.new
  end

  def create
    @business_unit = BusinessUnit.new business_unit_params
    if @business_unit.save
      redirect_to business_units_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @business_unit.update_attributes business_unit_params
      redirect_to business_units_url
    else
      render :edit
    end
  end

  def destroy
    @business_unit.destroy
    redirect_to business_units_url
  end

  private
    def business_unit_params
      params.require(:business_unit).permit(:name)
    end

    def set_business_unit
      @business_unit = BusinessUnit.where(:id => params[:id]).first
      unless @business_unit
        redirect_to business_units_url, alert: "Business Unit not found"
      end
    end
end