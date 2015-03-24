class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :answer_options
  has_many :question_options, :through => :answer_options
  
  validates :question, :presence => true

  validate :validate_answer

  private
    def validate_answer
      if question.present?
        if question.single_select? && answer_options.many?
          errors[:base] << "Only one option can be selected"
        end
      end
    end
end