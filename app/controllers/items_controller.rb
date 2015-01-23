class ItemsController < ApplicationController

  before_action :set_item, :only => [:edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new item_params
    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update_attributes item_params
      redirect_to items_path
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path
  end

  private
    def item_params
      params.require(:item).permit(:name, :city_id, :item_region_id, :category_id, :subcategory_id, :short_description, :collection_id, :size_id, :alcohol_percent_id, :quantity, :unit_of_measurement, :image_ids => [], :prices => [:name, :value], :details => [:name, :value])
    end

    def set_item
      @item = Item.where(:id => params[:id]).first
      unless @item
        redirect_to items_path, :alert => "Item not found"
      end
    end
  
end