class ImagesController < ApplicationController

  def new
    @image = Image.new
  end
  
  def create
    @image = Image.new image_params
    if @image.save
      respond_to do |format|
        format.html { redirect_to images_path }
        format.js
        format.json {
          render :json => { :result => true, :image => { :id => @image.id, :image_url => @image.image_url } }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { :result => false, :errors => { :messages => @image.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def image_params
      params.require(:image).permit(:image)
    end
end