class ItemRegionsController < ApplicationController

  def new
    @item_region = ItemRegion.new
  end
  
  def create
    @item_region = ItemRegion.new item_region_params
    if @item_region.save
      respond_to do |format|
        format.html { redirect_to item_regions_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def item_region_params
      params.require(:item_region).permit(:name)
    end
end