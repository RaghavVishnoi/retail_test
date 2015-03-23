class SurveysController < ApplicationController

  PER_PAGE = 20

  before_action :set_survey, :only => [:edit, :update, :destroy]

  authorize_resource

  def index
    @surveys = Survey.paginate(:per_page => PER_PAGE, :page => params[:page] || '1')
    respond_to do |format|
      format.html
      format.json do
        render :json => { result: true, :per_page => @surveys.per_page, :length => @surveys.length, :current_page => @surveys.current_page, :total_pages => @surveys.total_pages, :updated_at => Time.current, :surveys => ActiveModel::ArraySerializer.new(@surveys, :each_serializer => SurveySerializer) }
      end
    end
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