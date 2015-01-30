class InventoriesController < ApplicationController

  before_action :set_item
  before_action :set_inventory, :only => [:edit, :update, :destroy]

  def index
    @inventories = @item.inventories
    respond_to do |format|
      format.html
      format.json {
        render :json => { :result => true, :inventories => @inventories.as_json }
      }
    end
  end

  def new
    @inventory = @item.inventories.new
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :inventory => @inventory.as_json }
      }
    end
  end

  def create
    @inventory = @item.inventories.new inventory_params
    if @inventory.save
      respond_to do |format|
        format.html { redirect_to item_inventories_path(@item) }
        format.json { 
          render :json => { :result => true, :inventory => @inventory.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json {
          render :json => { :result => false, :errors => { :messages => @inventory.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json {
        render :json => { :result => true, :inventory => @inventory.as_json }
      }
    end
  end

  def update
    if @inventory.update_attributes inventory_params
      respond_to do |format|
        format.html { redirect_to item_inventories_path(@item) }
        format.json { 
          render :json => { :result => true, :inventory => @inventory.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { :result => false, :errors => { :messages => @inventory.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @inventory.destroy
      respond_to do |format|
        format.html { redirect_to item_inventories_path(@item) }
        format.json {
          render :json => { :result => true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to item_inventories_path(@item), :alert => @inventory.errors.full_messages.to_sentence }
        format.json {
          render :json => { :result => false, :errors => { :messages => @inventory.errors.full_messages } }
        }
      end
    end
  end

  private
    def set_item
      @item = Item.where(:id => params[:item_id]).first
      unless @item
        respond_to do |format|
          format.html { redirect_to items_path, alert: "Item not found" }
          format.json {
            render :json => { :result => false, :errors => { :messages => ["Item not found"] } }
          }
        end
      end
    end

    def set_inventory
      @inventory = @item.inventories.where(:id => params[:id]).first
      unless @inventory
        respond_to do |format|
          format.html { redirect_to item_inventories_path(@item), alert: "Inventory not found" }
          format.json {
            render :json => { :result => false, :errors => { :messages => ["Inventory not found"] } }
          }
        end
      end
    end

    def inventory_params
      params.require(:inventory).permit(:quantity, :warehouse_id, :low_stock_trigger_quantity, :restock_time)
    end
end