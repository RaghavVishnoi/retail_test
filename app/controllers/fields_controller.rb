class FieldsController < ApplicationController
  
  before_action :set_field, :only => [:edit, :update, :destroy]

  def index
    @fields = Field.all
  end

  def new
    @field = Field.new
  end

  def edit
  end

  def create
    @field = Field.new field_params
    if @field.save
      redirect_to fields_path
    else
      render :new
    end
  end

  def update
    if @field.update_attributes field_params
      redirect_to fields_path
    else
      render :edit
    end
  end

  def destroy
    @field.destroy
    redirect_to fields_path
  end

  private

    def field_params
      params.require(:field).permit(:name, :display_name, :entity, :field_type, :value_type, :configuration => { :values => [] })
    end

    def set_field
      @field = Field.where(:id => params[:id]).first
      unless @field
        redirect_to fields_path, alert: "Field not found"
      end
    end

end