class Organization < ActiveRecord::Base
  validates :name, :logo, :presence => true
  mount_uploader :logo, LogoUploader
end