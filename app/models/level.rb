class Level < ActiveRecord::Base
	validates :level_name,:presence => true
end
