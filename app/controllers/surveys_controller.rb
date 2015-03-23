class SurveysController < ApplicationController

  PER_PAGE = 20

  before_action :set_survey, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    @surveys = Survey.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new survey_params
    if @survey.save
      redirect_to surveys_path
    else
      render :new
    end
  end

  def update
    if @survey.update_attributes survey_params
      redirect_to surveys_path
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_path
  end

  private
    def survey_params
      params.require(:survey).permit(:heading, :questions_attributes => [:question_type, :id, :content, :question_options_attributes => [:id, :content]])
    end

    def set_survey
      @survey = Survey.where(:id => params[:id]).first
      unless @survey
        redirect_to surveys_path
      end
    end
end