class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new category_params
    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path }
        format.js
      end
    else
      render :new
    end
  end
  
  private
    def category_params
      params.require(:category).permit(:name)
    end
end