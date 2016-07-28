class Contact < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  belongs_to :customer

  validates :first_name, :presence => true
end