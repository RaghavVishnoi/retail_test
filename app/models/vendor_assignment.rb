class VendorAssignment < ActiveRecord::Base

	def self.assignments(params,current_user)
		start_date = if params[:from] != '' && params[:from] != nil then params[:from].to_date else (Time.now - 1.month).to_date end
    	end_date = if params[:to] != '' && params[:to] != nil then params[:to].to_date else Time.now.to_date end
		VendorAssignment.where(vendor_id: current_user.id,status: params[:q][:status].split(',').map(&:capitalize),assigned_date: start_date.beginning_of_day..end_date.end_of_day)   
	end

	def self.get_request_detail(vendor_assignment)
		Request.find_by(:id => vendor_assignment.request_id)
	end

	def self.get_retailer_detail(retailer_code)
		Retailer.find_by(:retailer_code => retailer_code)
	end

	def self.get_cmo_detail(id)
		CMO.find_by(:id => id)
	end

	def self.get_assignment_id(assignments)
		assignment_id = []
		assignments.each do |assignment|
			assignment_id.push(assignment.id)
		end
		assignment_id
	end
 

	##############################
	def self.request_assignments(params,current_user)
		start_date = if params[:from] != '' && params[:from] != nil then params[:from].to_date else (Time.now - 1.month).to_date end
    	end_date = if params[:to] != '' && params[:to] != nil then params[:to].to_date else Time.now.to_date end
		RequestAssignment.where(user_id: current_user.id,assign_date: start_date.beginning_of_day..end_date.end_of_day).joins(:request).where("request_type = ?",params[:q][:request_type])
	end

	def self.update_status(params)
		case params[:status]
		when 'po_receive'
			RequestAssignment.find(params[:id]).update(po_number: params[:po_number])
			VendorStage.new(stage_name: params[:status],request_assignment_id: params[:id],update_date: Time.parse(params[:date])).save
			VendorStage.new(stage_name: 'started',request_assignment_id: params[:id],update_date: Time.now)
		else
			VendorStage.new(stage_name: params[:status],request_assignment_id: params[:id],update_date: Time.now)
		end
	end

	 

end
