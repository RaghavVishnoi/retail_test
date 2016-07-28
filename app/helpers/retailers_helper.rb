module RetailersHelper
	require 'httparty'
	def zedsales_upload(begin_time,end_time)
		param1 = ZED_SALES_PARAMS[0]
		param2 = ZED_SALES_PARAMS[1]
		url = ZED_SALES_URL[0]+'&'+param1+'='+begin_time+'&'+param2+'='+end_time
		response = HTTParty.get(url)
		json = JSON.parse(response.body)
		if json[0].values[0] != 0
		    retailers_data = json[0].values[1]
		    retailers_data.each do |data|
		    	retailer_code = data['RetailerCode']
		    	if Retailer.exists?(:retailer_code => retailer_code)
		    		update_retailer(data)
		    	else
		    		create_retailer(data)
		    	end
		    end
		end    	
	end

	def update_retailer(data)
		if data['Status'] == '1'
			@status =  "Active"
		else
			@status =  "Inactive"
		end
		retailer = Retailer.find_by(:retailer_code => data['RetailerCode'])
		retailer.update(:retailer_name => data['RetailerName'],:retailer_code => data['RetailerCode'],:sales_channel => data['SalesChannelName'],:contact_person => data['ContactPerson'],:state => data['StateName'],:city => data['CityName'],:pincode => data['PinCode'],:tin_number => data['TinNumber'],:mobile_number => data['MobileNumber'],:status => @status,:is_isp_on_counter => '',:counter_size => data['CounterSize'],:nd => data['ND'],:address => data['RetailerAddress'],:location_code => data['MUMCode'],:salesman_id => data['SalesmanID'])
	end

	def create_retailer(data)
		if data['Status'] == '1'
			@status =  "Active"
		else
			@status =  "Inactive"
		end
		Retailer.create(:retailer_name => data['RetailerName'],:retailer_code => data['RetailerCode'],:sales_channel => data['SalesChannelName'],:contact_person => data['ContactPerson'],:state => data['StateName'],:city => data['CityName'],:pincode => data['PinCode'],:tin_number => data['TinNumber'],:mobile_number => data['MobileNumber'],:status => @status,:is_isp_on_counter => '',:counter_size => data['CounterSize'],:nd => data['ND'],:address => data['RetailerAddress'],:location_code => data['MUMCode'],:salesman_id => data['SalesmanID'])
	end
end
