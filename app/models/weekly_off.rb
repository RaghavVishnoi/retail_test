class WeeklyOff < ActiveRecord::Base
  enum day: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
  has_and_belongs_to_many :users
  
  validates :day, :presence => true, :uniqueness => true
end