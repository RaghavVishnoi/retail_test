class Retailer < ActiveRecord::Base
	 
	validates :retailer_code, :presence => true, :uniqueness => {:message => "Retailer code can't be duplicate"}
	validates :retailer_name,:address,:state,:city,:status, :presence => {:message => "Some Values are required"}
    validate :mobile_number


def self.search(id)

	 @retailer = Retailer.where("retailer_code = ? OR state = ? OR city = ?", id,id,id) 

end

def self.insert_data(new_retailers_array,inactive_retailers_array,file)

  columns = Retailer.column_names
  update_retailers = inactive_retailers_array.split(',')
  @new_retailers_array = new_retailers_array.split(',')
  puts "new retailers_array #{@new_retailers_array}"
   string = file.original_filename.partition(".").last
   workbook = Roo::Spreadsheet.open(file.path, extension: string)
   columns = Retailer.column_names 
	   workbook.each_with_pagename  do |name, sheet|
		   	sheet.each_with_index  do |row,index|
			   	 unless index < 1
			   	 		
						if @new_retailers_array.include? row[1] 
							puts "here is row #{row[1]}"
							@file_read = Retailer.new
							 
					   	 	   (1...columns.length-2).each do |column_count|
					   	 	   	if columns[column_count] == 'retailer_code'
					   	 	  	    @file_read["#{columns[column_count]}"] = row[column_count-1].strip
					   	 	  	else
					   	 	  		@file_read["#{columns[column_count]}"] = row[column_count-1]
					   	 	  	end
					           end 
				            @file_read.save
				        	  
				   	 	end
			   	 end
		   	end
		   			
		   	        if inactive_retailers_array.size != 0
			            retailers_array = inactive_retailers_array.split(',')
			            puts "here is inactive_retailers_array #{inactive_retailers_array}"
			            update_retailer = Retailer.where( retailer_code: retailers_array ).update_all( status: 'Inactive' )

			             
			            
		            end
	   end
	   				
  
  
 end

def self.display_names
	
    all.map { |c| [c.display_name, c.id] }

  end

  def display_name

    name = Retailer.select(:state).uniq
   
  end

  
	 
end
