class Attendance < ActiveRecord::Base
  belongs_to :user
  mount_uploader :punch_in_image, ImageUploader
  mount_uploader :punch_out_image, ImageUploader

  validates :punch_in_image, :presence => true

  def self.between_time(start_time, end_time)
    where("punch_in_time between ? and ?", start_time, end_time)
  end
end