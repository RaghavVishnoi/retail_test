class SizesController < ApplicationController

  before_action :set_size, :only => [:edit, :update, :destroy]

  def index
    @sizes = Size.all
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :sizes => @sizes.as_json }
      }
    end
  end

  def new
    @size = Size.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :size => @size.as_json }
      }
    end
  end
  
  def create
    @size = Size.new size_params
    if @size.save
      respond_to do |format|
        format.html { redirect_to sizes_path }
        format.js
        format.json { 
          render :json => { result: true, :size => @size.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @size.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :size => @size.as_json } }
    end
  end

  def update
    if @size.update_attributes size_params
      respond_to do |format|
        format.html { redirect_to sizes_path }
        format.json {
          render :json => { result: true, :size => @size.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @size.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @size.destroy
      respond_to do |format|
        format.html { redirect_to sizes_path }
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to sizes_path, :alert => @size.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @size.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def size_params
      params.require(:size).permit(:name)
    end

    def set_size
      @size = Size.where(:id => params[:id]).first
      unless @size
        respond_to do |format|
          format.html { redirect_to sizes_path, :alert => "Size not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Size not found"] } } }
        end
      end
    end
end