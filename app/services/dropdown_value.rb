class DropdownValue  

def self.data
	response = {}
	response['avg_gionee_monthly_sales'] = AVG_GIONEE_MONTHLY_SALES,
	response['avg_store_monthly_sales'] = AVG_STORE_MONTHLY_SALES,
	response['cmo_name'] = CMO.display_names.compact,
	response['is_main_signage'] = BOOLEAN_VALUES,
	response['is_sis_installed'] = BOOLEAN_VALUES,
	response['is_gionee_gsb_present'] = BOOLEAN_VALUES,
	response['is_rsp'] = BOOLEAN_VALUES,
	response['state'] = STATES,
	response['sis_types'] = SIS_TYPES,
	response['space_available'] = SPACE_AVAILABLE,
	response['gsb_types'] = GSB_TYPES,
	response['requirement_for_this_shop'] = REQUIREMENT_FOR_THIS_SHOP,
	response['rsp_not_present_reason'] = RSP_NOT_PRESENT_REASON,
	response['is_gsb_installed_outside'] = BOOLEAN_VALUES,
	response['retailer_state'] = Retailer.order(:state).all.map {|a| [a.state]}.uniq,
	response['type_of_issue'] = [['"SIS"'],['"GSB"'],['"Clipon"'],['"Countertop"'],['"Standee"'],['"Other"']],
	response['type_of_problem'] = [['"Damage to material"'],['"Electrical – lights etc not working"'],['"Security System related"'],['"Wrong Placement – Need to shift location"'],['"Wrong Shop – Need to remove from shop"'],['"Quality / finish issue"'],['"Visual / artwork to be changed"'],['"other"']],
	response['visitor_boolean_values'] = VISITOR_BOOLEAN_VALUES,
	response['no_of_peices_in_stock'] = No_OF_PIECES_IN_STOCK,
	response['gsb_type_installed'] = GSB_TYPE_INSTALLED,
	response['location_of_gsb'] = LOCATION_OF_GSB,
 	response['gsb_cleanliness'] = GSB_CLEANLINESS,
	response['installation_quality'] = INSTALLATION_QUALITY,
	response['security_alarm_working'] = SECURITY_ALARM_WORKING,
	response['demo_phones_installed'] = DEMO_PHONES_INSTALLED,
	response['selling_skills'] = SELLING_SKILLS,
 	response['vendor_verify'] = VENDOR_VERIFY,
	response['vendor_list'] = Vendorlist.display_names.compact,
	response['installation_of'] = INSTALLATION_OF,
	response['installation_report'] = INSTALLATION_REPORT,
	response['overall_rating'] = OVERALL_RATING
	response



end

end