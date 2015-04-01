class AppsController < ApplicationController
  before_action :find_app, :only => [:edit, :update, :destroy]
  authorize_resource

  def index
    @apps = App.all
  end

  def new
    @app = App.new
  end

  def create
    @app = App.new app_params
    if @app.save
      redirect_to apps_path
    else
      render :new
    end
  end

  def update
    if @app.update_attributes app_params
      redirect_to apps_path
    else
      render :edit
    end
  end

  def destroy
    @app.destroy
    redirect_to apps_path
  end

  private
    def app_params
      params.require(:app).permit(:name)
    end

    def find_app
      @app = App.where(:id => params[:id]).first
      unless @app
        redirect_to apps_path
      end
    end

end