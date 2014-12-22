class Organization < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
  validates :name, :logo, :presence => true
end