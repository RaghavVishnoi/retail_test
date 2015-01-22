class CollectionsController < ApplicationController

  def new
    @collection = Collection.new
  end
  
  def create
    @collection = Collection.new collection_params
    if @collection.save
      respond_to do |format|
        format.html { redirect_to collections_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def collection_params
      params.require(:collection).permit(:name)
    end
end