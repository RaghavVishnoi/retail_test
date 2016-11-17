class TatGroup < ActiveRecord::Base

	validates :name,presence: true
	validates :duration, presence: true

	def self.isTatLimit?(moduleName,lastUpdateDate)
		begin
			if self.find_by(name: moduleName) != nil
				if lastUpdateDate+self.find_by(name: moduleName).duration.days <= Time.now
					true
				else
					false
				end
			else
				true
			end
		rescue
			false
		end	
	end

end
