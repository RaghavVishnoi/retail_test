class VendorStage < ActiveRecord::Base

	belongs_to :vendor_requests
	belongs_to :request_assignment
   
	after_save :update_assignment


	def self.date_difference(stages,prev_index)
		if stages[prev_index] == 'po_receive'
			days = (find_by(stage_name: stages[prev_index.to_i+1]).update_date - find_by(stage_name: 'accepted').update_date)
		else
			days = (find_by(stage_name: stages[prev_index.to_i+1]).update_date - find_by(stage_name: stages[prev_index]).update_date)
		end		
		time = (days/(24*60*60))
		if time < 1.0
			hours = (time*24)
			if hours < 1.0
				(hours*60).to_i.to_s + " Minutes"
			else
				hours.to_i.to_s + " Hours"
			end
		else
			time.to_i.to_s + " Day"
		end
	end

	private
		def update_assignment
			case self.stage_name
			when 'accepted'
				@request_assignment = RequestAssignment.find(self.request_assignment_id).update(current_stage: self.stage_name,status: 'accepted')			
			when 'declined'
				@request_assignment = RequestAssignment.find(self.request_assignment_id).update(current_stage: self.stage_name,status: 'declined')			
			when 'started'
				@request_assignment = RequestAssignment.find(self.request_assignment_id).update(current_stage: self.stage_name,status: 'started')			
				self.request_assignment.request.update(is_fixed: 1)
			when 'bill_received'
				@request_assignment = RequestAssignment.find(self.request_assignment_id).update(current_stage: self.stage_name,status: 'bill_received',upload_bill: 1)			
			else
				@request_assignment = RequestAssignment.find(self.request_assignment_id).update(current_stage: self.stage_name)			
			end
			RequestAssignment.add_activity(self.request_assignment.user_id,self.stage_name,self.request_assignment)
		end



end
