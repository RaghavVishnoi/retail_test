class AlcoholPercentsController < ApplicationController

  before_action :set_alcohol_percent, :only => [:edit, :update, :destroy]

  def index
    @alcohol_percents = AlcoholPercent.all
    respond_to do |format|
      format.html
      format.json {
        render :json => { result: true, :alcohol_percents => @alcohol_percents.as_json }
      }
    end
  end

  def new
    @alcohol_percent = AlcoholPercent.new
    respond_to do |format|
      format.html
      format.js
      format.json { 
        render :json => { result: true, :alcohol_percent => @alcohol_percent.as_json }
      }
    end
  end
  
  def create
    @alcohol_percent = AlcoholPercent.new alcohol_percent_params
    if @alcohol_percent.save
      respond_to do |format|
        format.html { redirect_to alcohol_percents_path }
        format.js
        format.json { 
          render :json => { result: true, :alcohol_percent => @alcohol_percent.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render :new }
        format.json {
          render :json => { result: false, :errors => { :messages => @alcohol_percent.errors.full_messages } }
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render :json => { result: true, :alcohol_percent => @alcohol_percent.as_json } }
    end
  end

  def update
    if @alcohol_percent.update_attributes alcohol_percent_params
      respond_to do |format|
        format.html { redirect_to alcohol_percents_path }
        format.json {
          render :json => { result: true, :alcohol_percent => @alcohol_percent.as_json }
        }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json {
          render :json => { result: false, :errors => { :messages => @alcohol_percent.errors.full_messages } }
        }
      end
    end
  end

  def destroy
    if @alcohol_percent.destroy
      respond_to do |format|
        format.html { redirect_to alcohol_percents_path}
        format.json { 
          render :json => { result: true }
        }
      end
    else
      respond_to do |format|
        format.html { redirect_to alcohol_percents_path, :alert => @alcohol_percent.errors.full_messages.to_sentence }
        format.json { 
          render :json => { result: false, :errors => { :messages => @alcohol_percent.errors.full_messages } }
        }
      end
    end
  end
  
  private
    def alcohol_percent_params
      params.require(:alcohol_percent).permit(:value)
    end

    def set_alcohol_percent
      @alcohol_percent = AlcoholPercent.where(:id => params[:id]).first
      unless @alcohol_percent
        respond_to do |format|
          format.html { redirect_to alcohol_percents_path, :alert => "Alcohol Percent not found" }
          format.json { render :json => { :result => false, :errors => { :messages => ["Alcohol Percent not found"] } } }
        end
      end
    end
end