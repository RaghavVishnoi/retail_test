class ItemsController < ApplicationController

  PER_PAGE = 20

  before_action :set_item, :only => [:edit, :update, :destroy]
  
  before_action :initialize_resources, :only => [:index]

  authorize_resource

  def index
    @items = @items.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :per_page => @items.per_page, :length => @items.length, :current_page => @items.current_page, :total_pages => @items.total_pages, :updated_at => Time.current, :items => ActiveModel::ArraySerializer.new(@items, :each_serializer => ItemSerializer) }
      }
    end
  end

  def autocomplete
    @items = Item.with_name(params[:q]).pluck(:name, :id)
    render :json => @items, root: false
  end

  def new
    @item = Item.new
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :item => @item.as_json }
      }
    end
  end

  def create
    @item = Item.new item_params
    if @item.save
      respond_to do |format|
        format.html { redirect_to items_path }
        format.json {
          render :json => { result: true, :item => ItemSerializer.new(@item, :root => false) }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @item.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :item => ItemSerializer.new(@item, :root => false) } }
    end
  end

  def update
    if @item.update_attributes item_params
      respond_to do |format|
        format.html { redirect_to items_path }
        format.json {
          render :json => { result: true, :item => ItemSerializer.new(@item, :root => false) }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @item.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_path }
      format.json {
        render :json => { result: true }
      }
    end
  end

  private
    def item_params
      params.require(:item).permit(:name, :city_id, :item_region_id, :category_id, :subcategory_id, :short_description, :collection_id, :size_id, :alcohol_percent_id, :quantity, :unit_of_measurement, :image_ids => [], :prices => [:name, :value], :details => [:name, :value], :properties => [:field_id, :value])
    end

    def set_item
      @item = Item.where(:id => params[:id]).first
      unless @item
        respond_to do |format|
          format.html { redirect_to items_path, :alert => "Item not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Item not found"] } } }
        end
      end
    end
  
end
