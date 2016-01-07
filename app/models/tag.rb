class Tag < ActiveRecord::Base
	validates :tag_name,:presence => true
end
