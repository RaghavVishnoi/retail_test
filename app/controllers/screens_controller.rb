class ScreensController < ApplicationController
  skip_before_action :authenticate_user, :only => [:index, :show]
  skip_authorize_resource :only => [:index, :show]
  before_action :set_screen, :only => [:edit, :show, :update, :destroy]
  
  PER_PAGE = 20

  def index
    @screens = Screen.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html 
      format.json { render :json => { :result => true, :per_page => @screens.per_page, :length => @screens.length, :current_page => @screens.current_page, :total_pages => @screens.total_pages, :screens => @screens.as_json } }
    end
  end

  def new
    @screen = Screen.new
  end

  def show
    respond_to do |format|
      format.json { render :json => { :result => true, :screen => @screen.layout } }
    end
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
        respond_to do |format|
          format.html { redirect_to screens_path }
          format.json { render :json => { :result => false, :errors => { :messages => ["Screen not found"] } } }
        end
      end
    end
end