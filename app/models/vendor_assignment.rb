class VendorAssignment < ActiveRecord::Base

	self.table_name = "vendor_requests"
	has_many :vendor_stages

	def self.assignments(user_id,status)
		@users = User.find_by(:id => user_id)
    	if @users != nil && @users != ''
    	   @vendor = Vendorlist.where(:email => @users.email)
    	   if @vendor != nil && @vendor != ''
    	   	  VendorAssignment.where(:vendor_id => @vendor,:status => status.camelize) 
    	   end
    	end   
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

	def self.get_search_result(param,status,user_id)
		@users = User.find_by(:id => user_id)
    	if @users != nil && @users != ''
    	   @vendor = Vendorlist.where(:email => @users.email)
    	   if @vendor != nil && @vendor != ''
    	   	  @retailer = Retailer.where("retailer_code = ? OR state = ? OR city = ?", param,param,param).pluck(:retailer_code) 
    	   	  puts "here is status #{@retailer}"
    	   	  if @retailer.length == 0
    	   	  	    
    	   	  else
    	   	  	  @request = Request.where(:retailer_code => @retailer).pluck(:id)
	    	   	  @vendor_assignment = VendorAssignment.where(:vendor_id => @vendor,:status => status.camelize,:request_id => @request) 
    	   	 	  	
    	   	  end
    	   end
    	end   
	end

	def self.update_status(id,status)
		date = Date.today
		id.each do |req_id|
			@assignment = VendorAssignment.find_by(:id => req_id)
			@assignment.vendor_response = status.camelize
			if status == 'accepted'
				@assignment.status = 'Accepted'
			elsif status == 'bill_received'
				@assignment.status = 'Finished'
			elsif status == 'rejected'	
				@assignment.status = 'Rejected'		
			end
			@assignment.save
		end	
		@stages = VendorStage.new(:stage_name => status,:update_date => date,:vendor_request_id => @assignment.id)
		@stages.save
	end

end
