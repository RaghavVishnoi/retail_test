class AnswerOption < ActiveRecord::Base
  belongs_to :answer
  belongs_to :question_option

  validate :validate_option

  private
    def validate_option
      if question_option.present? && answer.present?
        if answer.question_id != question_option.question_id
          errors[:base] << "Invalid Option"
        end
      end
    end
end