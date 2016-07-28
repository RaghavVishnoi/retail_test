class CategoriesController < ApplicationController

  before_action :set_category, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    @categories = Category.all
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :categories => @categories.as_json }
      }
    end
  end

  def new
    @category = Category.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :category => @category.as_json }
      }
    end
  end
  
  def create
    @category = Category.new category_params
    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path }
        format.js
        format.json { 
          render :json => { result: true, :category => @category.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @category.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :category => @category.as_json } }
    end
  end

  def update
    if @category.update_attributes category_params
      respond_to do |format|
        format.html { redirect_to categories_path }
        format.json {
          render :json => { result: true, :category => @category.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @category.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @category.destroy
      respond_to do |format|
        format.html { redirect_to categories_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to categories_path, :alert => @category.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @category.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.where(:id => params[:id]).first
      unless @category
        respond_to do |format|
          format.html { redirect_to categories_path, :alert => "Category not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Category not found"] } } }
        end
      end
    end
end