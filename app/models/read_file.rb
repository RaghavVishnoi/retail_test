class ReadFile < ActiveRecord::Base

	@file

	def self.import(file,model)
	@file = file 
	@object = [] 
    @new_retailers = []
    @column_count = true
    string = file.original_filename.partition(".").last
	columns = model.column_names 
    workbook = Roo::Spreadsheet.open(file.path, extension: string)
    
     if model == Retailer

     	update = false
     	insert = false
     	 
     	retailer_code = Retailer.pluck(:retailer_code)
     	# @retailer_name = Retailer.pluck(:retailer_name)
     	@retailer_code = retailer_code
         
     	workbook.each_with_pagename  do |name, sheet|
		  sheet.each_with_index  do |row,index|
		  	        
		  	        if index == 0
					    if row[0] != 'RetailerName' || row[1] != 'RetailerCode' || row[2] != 'SalesChannelName' || row[3] != 'ContactPerson' || row[4] != 'StateName' || row[5] != 'CityName' || row[6] != 'PinCode' || row[7] != 'TinNumber' || row[8] != 'MobileNumber' || row[9] != 'StatusValue' || row[10] != 'RSPOnCounter' || row[11] != 'CounterSize' || row[12] != 'RecordCreationDate' || row[13] != 'ND'
		    	    		@column_count = false

		    	    	end	

		    	    else
		    	      if @column_count != false	
		    	 		if retailer_code.include?(row[1])
		    	 		    	@retailer_code.delete(row[1])
		    	 		    	# @retailer_name.delete(row[0])
						else
							     
							    @new_retailers.push(row)
								 
					     end
					 end
					end    	
					
	      end
	   end
		  
	    
     end
  if @column_count != false
  	@retailer_name = Retailer.where(:retailer_code => @retailer_code).pluck(:retailer_name)
  	puts "here is retailer name #{@retailer_name}"
  	@object.push(@new_retailers)
    @object.push(@retailer_code)
    @object.push(@retailer_name)

  else
	@object.push(false)
  end
     
end


  def self.file_insert
  	@file
  end
end
