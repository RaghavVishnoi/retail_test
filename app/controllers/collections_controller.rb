class CollectionsController < ApplicationController

  before_action :set_collection, :only => [:edit, :update, :destroy]
  
  authorize_resource

  def index
    @collections = Collection.all
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :collections => @collections.as_json }
      }
    end
  end

  def new
    @collection = Collection.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :collection => @collection.as_json }
      }
    end
  end
  
  def create
    @collection = Collection.new collection_params
    if @collection.save
      respond_to do |format|
        format.html { redirect_to collections_path }
        format.js
        format.json { 
          render :json => { result: true, :collection => @collection.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @collection.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :collection => @collection.as_json } }
    end
  end

  def update
    if @collection.update_attributes collection_params
      respond_to do |format|
        format.html { redirect_to collections_path }
        format.json {
          render :json => { result: true, :collection => @collection.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @collection.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @collection.destroy
      respond_to do |format|
        format.html { redirect_to collections_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to collections_path, :alert => @collection.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @collection.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def collection_params
      params.require(:collection).permit(:name)
    end

    def set_collection
      @collection = Collection.where(:id => params[:id]).first
      unless @collection
        respond_to do |format|
          format.html { redirect_to collections_path, :alert => "Collection not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Collection not found"] } } }
        end
      end
    end
end