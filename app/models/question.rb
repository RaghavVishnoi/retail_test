class Question < ActiveRecord::Base
  enum question_type: ['text', 'single_select', 'multiple_select']

  belongs_to :survey
  has_many :question_options, :dependent => :destroy

  accepts_nested_attributes_for :question_options
  
  validates :content, :presence => true
end