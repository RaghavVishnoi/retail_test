class Picture < ActiveRecord::Base
	belongs_to :object, :polymorphic => true
	mount_uploader :picture, PictureUploader 
end
