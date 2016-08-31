json.result true
json.object @shop_assignments.map{|assignment| if assignment.retailer != nil then  assignment.retailer.retailer_code end}
	