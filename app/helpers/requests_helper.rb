module RequestsHelper

	def shop_branding_details(start_date,end_date,state)
		if state == nil || state.length == 0 || state == 'All'
			 @state = Retailer.all.pluck(:state).uniq
		else
			 @state = state.split(',')
		end
		@count = Request.where(:state => @state,:created_at => start_date..end_date).group(:request_type,:state,:status).order('request_type ASC').count('status')
		request = []		
			TYPE.each do |type|
				types = {}
				data = []
		    	types[:request_type] = REQ_TYPE[type]
				@state.each do |state|
					@stat = {:approved => 0,:declined => 0,:pending => 0,:cmo_pending => 0,:cmo_declined => 0,:fixed => 0,:in_transit => 0,:audited => 0}
					if state.kind_of?(Array)
						@stat[:state] = state.join(',')
					else
						@stat[:state] = state
					end
					@count.each do |key,value|
						if key[0] == type && key[1] == state 
							@stat[key[2]] = value
						end

					end
					data.push(@stat)
				end
				types[:data] = data
				request.push(types)
			end
		request
	end

	def shop_list_details(start_date,end_date,request_type,states)
		type = []
		type_request = Request.where(:request_type => request_type(request_type),:created_at => start_date..end_date)
		@states = state(states)
		@states.each do |state|			
		    state_request = find_request_by_state(type_request,state)
		    STAT.each do |status|
		    	    status_request = find_request_by_status(state_request,status)				
					status_request.each do |request|
					   @stat = {}
			           @stat[:state] = state	
					   @stat[:id] = request.id	
					   @stat[:date] = request.created_at
					   @stat[:request_type] = request.request_type
					   retailer = find_shop_by_retailer(request.retailer_code)
					   @stat[:retailer_code] = request.retailer_code
					   if retailer != nil
					    @stat[:shop_name] = retailer.retailer_name
					   else
					   	@stat[:shop_name] = 'Undefined'
					   end					   
					    @stat[:status] = request.status.camelize
					    type.push(@stat)
					end			
			end
		end
		type.uniq
	end

	def request_details(id)
		type = {}
		request = Request.find(id)
		retailer = find_shop_by_retailer(request.retailer_code)
		type[:retailer_code] = request.retailer_code
		if retailer != nil
			type[:shop_name] = retailer.retailer_name
			type[:contact_person] = retailer.contact_person
			type[:address] = retailer.address
		else
			type[:shop_name] = 'Undefined'
			type[:contact_person] = 'Undefined'
			type[:address] = 'Undefined'
		end
		beatroute = Beatroute.find_by(:retailer_code => request.retailer_code,:created_at => request.created_at.prev_month..request.created_at)
		if beatroute != nil
			type[:vol_sale] = beatroute.mtd_avg_sales_volume
			type[:last_month_sale] = beatroute.last_month_avg_sales_volume
		else
		    type[:vol_sale] = 'N/A'
			type[:last_month_sale] = request.avg_store_monthly_sales
		end	
		type[:last_month_average_sale] = request.avg_gionee_monthly_sales
		@audit_date = Request.where(:retailer_code => request.retailer_code,:request_type => 4).last
		if @audit_date != nil 
		  type[:audited] = @audit_date.created_at
		else
		  type[:audited] = 'No'
		end
		images = Image.where(:imageable_id => request.id)
		url = []
		if images != nil
			images.each do |image|
				image_url = image.image.to_s
				 url.push('http://requesterapp.gionee.co.in'+image_url)
			end	
	    type[:image] = url	
		else
			type[:image] = ''
		end	
		type
	end

	def shop_data(state,start_date,end_date)
		sql = "select temp1.*,temp2.*,im.lat,im.long,im.image,im.id from 
		(select rs.retailer_name,rs.state,rs.city,rs.counter_size, rs.retailer_code rsrc from retailers rs where state='#{state}'
		 AND status='Active') as temp1 left outer join (select rq.id,rq.request_type,
		 rq.status,rq.created_at,rq.cmo_approve_date,approver_approve_date,rq.avg_store_monthly_sales,rq.retailer_code rqrc from requests rq where 
		 rq.created_at BETWEEN '#{start_date}' AND '#{end_date}' AND
		  rq.request_type != 3 AND rq.retailer_code in (select rs.retailer_code rsrc 
		  	from retailers rs where state='#{state}' AND status='Active')) as temp2 on temp1.rsrc = temp2.rqrc  left outer join images im on im.imageable_id=temp2.id;"

					@result = ActiveRecord::Base.connection.execute(sql)
					results = {}
					@result.each do |result|
						shop_data = {}
						if results.has_key?(result[4])
							values = results[result[4]]
							value = values[:request]
							req = {}
							if result[5] != nil 
								req[:id] = result[5]
								req[:request_type] = REQUEST_TYPE[result[6].to_i]
								req[:created_at] = result[8]
								req[:cmo_approve_date] = result[9]
								req[:approver_approve_date] = result[10]
								req[:status] = result[7]
								value.push(req)
								values[:request] = value
								values[:lat] = result[13]
								values[:long] = result[14]
								image_url = "http://requesterapp.gionee.co.in/uploads/image/image"+"/"+result[16].to_s+"/"+result[15].to_s
								values[:image_url] = image_url
								values[:sales_volume] = result[11]
								if result[6] == 4
									values[:shop_visit_date] = result[8]
								end
								results[result[4]] = values
							else
								results[result[4]] = values								
							end

						else
							requests = []
							request = {}
							shop_data[:shop_name] = result[0]
							shop_data[:city] = result[2]
							shop_data[:state] = result[1]
							shop_data[:retailer_code] = result[4]
							shop_data[:counter_size] = result[3]
							results[result[4]] = shop_data
							if result[5] != nil
								request[:id] = result[5]
								request[:request_type] = REQUEST_TYPE[result[6].to_i]
								request[:created_at] = result[8]
								request[:cmo_approve_date] = result[9]
								request[:sales_volume] = result[10]
								request[:status] = result[7]
								shop_data[:lat] = result[13]
								shop_data[:long] = result[14]
								shop_data[:avg_gionee_monthly_sales] = result[11]
								if result[6] == 4
									shop_data[:shop_visit_date] = result[8]
								else
									shop_data[:shop_visit_date] = 'No Record'
								end
								requests.push(request)	
														
							else
							    '[]'	
							end
							shop_data[:request] = requests
					    end
					end
					results.values
	     
		
	end

	def find_shop_location(id)
		Image.find_by(imageable_id: id)
	end

	def find_shop_by_retailer(retailer_code)
		Retailer.find_by(:retailer_code => retailer_code)
	end


    def find_request_by_state(request,state)
    	request.where(:state => state)
    end

    def find_request_by_request_type(request_type)
    	Request.where(:request_type => request_type)
    end

    def find_request_by_date(request,start_date,end_date)
    	request.where(:created_at => start_date..end_date)
    end

    def find_request_by_status(request,status)
    	if status == 'pending'
    		@request = request.where(:status => ['cmo_pending','pending'])
    	elsif status == 'declined'
    		@request = request.where(:status => ['cmo_declined','declined'])
    	else
    		@request = request.where(:status => status)
    	end	
    	@request
    end

	def request_type(type)
		case type
		when 'all','All'	
			[0,1,2,3,4]
		when 'gsb','GSB'
			0
		when 'sis','SIS'
			1
		when 'in_shop','IN_SHOP'
			2
		when 'maintenance','MAINTENANCE'
			3
		when 'visitor','VISITOR'
			4
		end
	end



	def state(value)
			if value == 'all' || value == 'All' || value == 'ALL'
				Retailer.order(:state).all.map {|a| [a.state]}.uniq
			else
				value.split(',')
			end	
	end

	def cmo_id(id,role)
		if role.include?('cmo')
		 user = User.find_by(:id => id)
	     email = user.email
	     cmo = CMO.find_by(:email => email)
	     cmo_id = cmo.id
	    else
	    	 ''
	    end
	end

	def request_data(id)
		Request.find_by(:id => id)
	end

	def requests_search(role,type,id,request_type,current_user)
                if type == 'Request Id'
                	if request_type.include?('0')
                		if request_data(id).request_type == 'sis' || request_data(id).request_type == 'in_shop' || request_data(id).request_type == 'gsb'
		                    "/requests/#{id}/edit"
		                end
		            elsif request_type.include?('3')   
		            	if request_data(id).request_type == 'maintenance'
		                    "/requests/#{id}/edit"
		                end
		            elsif request_type.include?('4')
		                if request_data(id).request_type == 'visitor'
		                    "/requests/#{id}/edit"
		                end 
                    end
                elsif type == 'RetailerCode'
                	if request_type.include?('0')
                		if role.include?('cmo')|| role.include?('supercmo')
                			"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end
                	elsif request_type.include?('3')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=3&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=3&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end
                	elsif request_type.include?('4')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=4&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=4&q[status][]=pending&q[status][]=approved&q[status][]=declined&retailer_code=#{URI::encode(id)}&type=RetailerCode"
                		end	
                	end	
                elsif type == 'State'
                	if request_type.include?('0')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=0&q[request_type][]=1&q[request_type][]=2&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end
                	elsif request_type.include?('3')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=3&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=3&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end
                	elsif request_type.include?('4')
                		if role.include?('cmo') || role.include?('supercmo')
                			"/requests?q[request_type][]=4&q[status][]=cmo_pending&q[status][]=pending&q[status][]=cmo_declined&state=#{URI::encode(id)}&type=State"
                		elsif role.include?('approver')
           					"/requests?q[request_type][]=4&q[status][]=pending&q[status][]=approved&q[status][]=declined&state=#{URI::encode(id)}&type=State"
                		end				
                	end		
			    end        
			 
	    
    end  
end