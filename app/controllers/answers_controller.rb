class AnswersController < ApplicationController
  def create
    answer = Answer.new answers_params
    if answer.save
      render :json => { :result => true }
    else
      render :json => { :result => false, :errors => { :messages => answer.errors.full_messages } }
    end
  end

  private
    def answers_params
      params.require(:answer).permit(:question_id, :content, :question_option_ids => [])
    end
end