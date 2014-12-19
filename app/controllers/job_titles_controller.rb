class JobTitlesController < ApplicationController
  
  before_action :set_job_title, :only => [:edit, :update, :destroy]

  def index
    @job_titles = JobTitle.all
  end

  def new
    @job_title = JobTitle.new
  end

  def create
    @job_title = JobTitle.new job_title_params
    if @job_title.save
      redirect_to job_titles_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @job_title.update_attributes job_title_params
      redirect_to job_titles_path
    else
      render :edit
    end
  end

  def destroy
    @job_title.destroy
    redirect_to job_titles_path
  end

  private
    def job_title_params
      params.require(:job_title).permit(:title)
    end

    def set_job_title
      @job_title = JobTitle.where(:id => params[:id]).first
      unless @job_title
        redirect_to job_titles_url, alert: "Job Title not found"
      end
    end
end