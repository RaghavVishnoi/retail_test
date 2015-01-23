class InventoriesController < ApplicationController

  before_action :set_item
  before_action :set_inventory, :only => [:edit, :update, :destroy]

  def index
    @inventories = @item.inventories
  end

  def new
    @inventory = @item.inventories.new
  end

  def create
    @inventory = @item.inventories.new inventory_params
    if @inventory.save
      redirect_to item_inventories_path(@item)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @inventory.update_attributes inventory_params
      redirect_to item_inventories_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to item_inventories_path(@item)
  end

  private
    def set_item
      @item = Item.where(:id => params[:item_id]).first
      unless @item
        redirect_to items_path, alert: "Item not found"
      end
    end

    def set_inventory
      @inventory = @item.inventories.where(:id => params[:id]).first
      unless @inventory
        redirect_to item_inventories_path(@item), alert: "Inventory not found"
      end
    end

    def inventory_params
      params.require(:inventory).permit(:quantity, :warehouse_id, :low_stock_trigger_quantity, :restock_time)
    end
end