class WarehousesController < ApplicationController

  def new
    @warehouse = Warehouse.new
  end
  
  def create
    @warehouse = Warehouse.new warehouse_params
    if @warehouse.save
      respond_to do |format|
        format.html { redirect_to warehouses_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def warehouse_params
      params.require(:warehouse).permit(:name)
    end
end
