class VendorRequest < ActiveRecord::Base

	belongs_to :requests
	has_many :vendor_stages
	validate :vendor_id,:vendor_response,:assigned_date,:status, :presence => true
    validates :vendor_id, :presence => true
    validates :request_id, :presence => true

	def self.vendor_email(id)
		email = Vendorlist.find_by(:id => id)
		
	end

	def self.get_unassigned_request
		@assigned_request = VendorRequest.all.where.not(:status => 'Rejected')
		assigned_request = []
		@assigned_request.each do |assignment|
			assigned_request.push(assignment.request_id)
			puts "here is unassigned request #{assignment.request_id}"
		 
		end
		assigned_request

	end

	def self.search(type,id)
		if type == 'Vendor Id'
			@vendor_request = VendorRequest.where(:vendor_id => id)
		elsif type == 'Request Id'
			@vendor_request = VendorRequest.where(:request_id => id)
		elsif type == 'Request Status'
			@vendor_request = VendorRequest.where(:status => id)
		elsif type == 'Vendor Response'
			@vendor_request = VendorRequest.where(:vendor_response => id)
		end
				
	end

	def self.array_insert(request_id,vendor_id,vendor_response,vendor_response_date,assigned_date,status)
		
		@vendor_request = VendorRequest.new
        @vendor_request.request_id = request_id
        @vendor_request.vendor_id = vendor_id
        @vendor_request.vendor_response = vendor_response
        @vendor_request.vendor_response_date = vendor_response_date
        @vendor_request.assigned_date = assigned_date
        @vendor_request.status = status
        @vendor_request.save
	end

	def self.filter(request_type,filter_type,id)
		if request_type == 'All Requests'
			request_type = [0,1,2,3,4]
		elsif request_type == 'GSB'
			request_type = 0
		elsif request_type == 'SIS'
			request_type = 1
		elsif request_type == 'In-shop'
			request_type = 2
		elsif request_type == 'Maintenance'
			request_type = 3
		elsif request_type == 'Audit'
			request_type = 4
		end

		  request=Request.arel_table
          assigned_request = VendorRequest.get_unassigned_request
          request = Request.where(Request.arel_table[:id].not_in(assigned_request))

		if filter_type == 'Retailer Code'
		  @request = request.where(:retailer_code => id,:request_type => request_type)
          
        elsif filter_type == 'Request Id'
          @request = request.where(:id => id,:request_type => request_type)
          	  
		elsif filter_type == 'State'
		  @request = request.where(:state => id,:request_type => request_type)

		elsif filter_type == 'City'
		  @request = request.where(:city => id,:request_type => request_type)
		end
	 end
  end
