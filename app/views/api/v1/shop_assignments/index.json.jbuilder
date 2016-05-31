	json.result true
	json.object do
     	json.assignments do
    		json.partial! "shop",collection: @shop_assignments,as: :assignment
    	end
	end
 