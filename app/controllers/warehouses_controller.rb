class WarehousesController < ApplicationController

  before_action :set_warehouse, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @warehouses = Warehouse.all
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :warehouses => @warehouses.as_json }
      }
    end
  end

  def new
    @warehouse = Warehouse.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :warehouse => @warehouse.as_json }
      }
    end
  end
  
  def create
    @warehouse = Warehouse.new warehouse_params
    if @warehouse.save
      respond_to do |format|
        format.html { redirect_to warehouses_path }
        format.js
        format.json { 
          render :json => { result: true, :warehouse => @warehouse.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @warehouse.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :warehouse => @warehouse.as_json } }
    end
  end

  def update
    if @warehouse.update_attributes warehouse_params
      respond_to do |format|
        format.html { redirect_to warehouses_path }
        format.json {
          render :json => { result: true, :warehouse => @warehouse.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @warehouse.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @warehouse.destroy
      respond_to do |format|
        format.html { redirect_to warehouses_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to warehouses_path, :alert => @warehouse.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @warehouse.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def warehouse_params
      params.require(:warehouse).permit(:name)
    end

    def set_warehouse
      @warehouse = Warehouse.where(:id => params[:id]).first
      unless @warehouse
        respond_to do |format|
          format.html { redirect_to warehouses_path, :alert => "Warehouse not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Warehouse not found"] } } }
        end
      end
    end
end