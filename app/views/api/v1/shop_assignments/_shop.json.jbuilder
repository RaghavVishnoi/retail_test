if assignment.retailer_id == -1
	retailer = Retailer.find_by(retailer_code: 'RT00')
else
	retailer = Retailer.find(assignment.retailer_id)
end
json.assignment_id assignment.id
json.retailer_code retailer.retailer_code
json.shop_name retailer.retailer_name
json.contact_person retailer.contact_person if retailer.contact_person != nil
json.contact_number retailer.mobile_number if retailer.mobile_number != nil
begin
	json.state State.where(name: retailer.state).pluck(:id,:name)
rescue
	json.state 'undefined'
end
json.city retailer.city
json.address retailer.address.tr("\n","") if retailer.address != nil
json.supervisor_name  UserParent.user_parent(assignment.user_id,'auditor').pluck(:name).join(',')
json.assign_date assignment.assign_date.strftime("%b %d,%Y") 