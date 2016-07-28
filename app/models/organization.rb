class Organization < ActiveRecord::Base
  include Fields

  mount_uploader :logo, LogoUploader
  
  validates :name, :logo, :presence => true
end