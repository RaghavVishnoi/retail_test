class SurveySerializer < ActiveModel::Serializer
  attributes :id, :heading, :updated_at, :created_at
  has_many :questions
end