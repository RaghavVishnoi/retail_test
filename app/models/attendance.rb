class Attendance < ActiveRecord::Base
  belongs_to :user
  mount_uploader :punch_in_image, ImageUploader
  mount_uploader :punch_out_image, ImageUploader

  validates :punch_in_image, :presence => true

  def self.between_time(start_time, end_time)
    where("punch_in_time between ? and ?", start_time, end_time)
  end

  def self.with_user_id(user_id)
    if user_id == 'all'
      self
    else
      where(:user_id => user_id)
    end
  end

  def status
    punch_in_time? ? 'Present' : 'Absent'
  end
end