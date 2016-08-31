retailer = Retailer.find(assignment.retailer_id)
json.assignment_id assignment.id
json.retailer_code if retailer.retailer_code != nil then retailer.retailer_code else 'No data' end
json.shop_name retailer.retailer_name if retailer.retailer_code != nil then retailer.retailer_name else 'No data' end
json.contact_person retailer.contact_person if retailer.retailer_code != nil then retailer.contact_person else 'No data' end
json.contact_number retailer.mobile_number if retailer.retailer_code != nil then retailer.mobile_number else 'No data' end
json.state State.where(name: retailer.state).pluck(:id,:name)
json.city retailer.city
json.address retailer.address.tr("\n","")
json.supervisor_name  UserParent.user_parent(assignment.user_id,'auditor').pluck(:name).join(',')
json.assign_date assignment.assign_date.strftime("%b %d,%Y") 