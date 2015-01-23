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
      end
    else
      render :new
    end
  end
  
  private
    def image_params
      params.require(:image).permit(:image)
    end
end