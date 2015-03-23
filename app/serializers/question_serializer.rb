class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :content, :question_type
  has_many :question_options
end