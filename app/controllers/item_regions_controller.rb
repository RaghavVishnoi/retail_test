class ItemRegionsController < ApplicationController

  PER_PAGE = 20

  before_action :set_item_region, :only => [:edit, :update, :destroy]

  def index
    @item_regions = ItemRegion.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :per_page => @item_regions.per_page, :length => @item_regions.length, :current_page => @item_regions.current_page, :total_pages => @item_regions.total_pages, :item_regions => @item_regions.as_json }
      }
    end
  end

  def new
    @item_region = ItemRegion.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :item_region => @item_region.as_json }
      }
    end
  end
  
  def create
    @item_region = ItemRegion.new item_region_params
    if @item_region.save
      respond_to do |format|
        format.html { redirect_to item_regions_path }
        format.js
        format.json { 
          render :json => { result: true, :item_region => @item_region.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @item_region.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :item_region => @item_region.as_json } }
    end
  end

  def update
    if @item_region.update_attributes item_region_params
      respond_to do |format|
        format.html { redirect_to item_regions_path }
        format.json {
          render :json => { result: true, :item_region => @item_region.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @item_region.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @item_region.destroy
      respond_to do |format|
        format.html { redirect_to item_regions_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to item_regions_path, :alert => @item_region.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @item_region.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def item_region_params
      params.require(:item_region).permit(:name)
    end

    def set_item_region
      @item_region = ItemRegion.where(:id => params[:id]).first
      unless @item_region
        respond_to do |format|
          format.html { redirect_to item_regions_path, :alert => "Item Region not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Item Region not found"] } } }
        end
      end
    end
end