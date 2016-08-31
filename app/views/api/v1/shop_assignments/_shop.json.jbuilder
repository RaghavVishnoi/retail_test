retailer = Retailer.find(assignment.retailer_id)
json.assignment_id assignment.id
json.retailer_code retailer.retailer_code
json.shop_name retailer.retailer_name
json.contact_person retailer.contact_person if retailer.contact_person != nil
json.contact_number retailer.mobile_number if retailer.mobile_number != nil
json.state State.where(name: retailer.state).pluck(:id,:name)
json.city retailer.city
json.address retailer.address.tr("\n","")
json.supervisor_name  UserParent.user_parent(assignment.user_id,'auditor').pluck(:name).join(',')
json.assign_date assignment.assign_date.strftime("%b %d,%Y") 