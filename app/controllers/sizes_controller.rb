class SizesController < ApplicationController

  def new
    @size = Size.new
  end
  
  def create
    @size = Size.new size_params
    if @size.save
      respond_to do |format|
        format.html { redirect_to sizes_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def size_params
      params.require(:size).permit(:name)
    end
end