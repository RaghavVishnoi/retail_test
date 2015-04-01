class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  belongs_to :imageable, :polymorphic => true

  validates :image, :presence => true
end