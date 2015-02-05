class ScreensController < ApplicationController
  before_action :set_screen, :only => [:edit, :update, :destroy]

  def index
    @screens = Screen.all
  end

  def new
    @screen = Screen.new
  end

  def edit
  end

  def create
    @screen = Screen.new screen_params
    if @screen.save
      redirect_to new_screen_path
    else
      render :new
    end
  end

  def update
    if @screen.update_attributes screen_params
      redirect_to screens_path
    else
      render :edit
    end
  end

  def destroy
    @screen.destroy
    redirect_to screens_path
  end

  private
    def screen_params
      params.require(:screen).permit!
    end

    def set_screen
      @screen = Screen.where(:id => params[:id]).first
      unless @screen
        redirect_to screens_path
      end
    end
end