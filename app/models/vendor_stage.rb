class VendorStage < ActiveRecord::Base

	belongs_to :vendor_requests
	belongs_to :request_assignment
   
	after_save :update_assignment


	def self.date_difference(stage,assignment)
		case stage
		when 'accepted'
			'0 Minutes'
		when 'po_receive'
			(Time.parse(assignment.vendor_stages.where(stage_name: 'po_receive').last.update_date.to_s).to_date - Time.parse(assignment.vendor_stages.where(stage_name: 'accepted').last.update_date.to_s).to_date).to_i.to_s+" Days"
		when 'started'
			(Time.parse(assignment.vendor_stages.where(stage_name: 'started').last.update_date.to_s).to_date - Time.parse(assignment.vendor_stages.where(stage_name: 'accepted').last.update_date.to_s).to_date).to_i.to_s+" Days"
		else
			(Time.parse(assignment.vendor_stages.where(stage_name: stage).last.update_date.to_s).to_date - Time.parse(assignment.vendor_stages.where(stage_name: PREV_STAGES[stage]).last.update_date.to_s).to_date).to_i.to_s+" Days"
		end	
		# if stages[prev_index] == 'accepted'
		# 	days = (find_by(stage_name: stages[prev_index.to_i+1]).update_date - find_by(stage_name: 'accepted').update_date)			
		# 	time(days)
		# else
		# 	days = (find_by(stage_name: stages[prev_index.to_i+1]).update_date - find_by(stage_name: stages[prev_index]).update_date)
		# 	time(days)
		# end		
		
	end

	def self.time(days) 
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
