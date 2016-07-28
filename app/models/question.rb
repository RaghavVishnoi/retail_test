class Question < ActiveRecord::Base
  enum question_type: ['text', 'single_select', 'multiple_select']

  belongs_to :survey
  has_many :question_options, :dependent => :destroy
  has_many :answers, :dependent => :destroy

  accepts_nested_attributes_for :question_options, :allow_destroy => true
  
  validates :content, :question_type, :presence => true
end