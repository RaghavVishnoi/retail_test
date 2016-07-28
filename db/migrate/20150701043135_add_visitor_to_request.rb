class AddVisitorToRequest < ActiveRecord::Migration
  def change
  	add_column :requests,:shop_visit_date,:string
  	add_column :requests,:shop_visit_done_by,:string
  	add_column :requests,:visitor_contact_number,:string
  	add_column :requests,:store_selling_gionee,:string
  	add_column :requests,:is_clipon_present,:string
  	add_column :requests,:is_countertop_present,:string
  	add_column :requests,:is_standee_present,:string
  	add_column :requests,:no_of_peace_in_stock,:string
  	add_column :requests,:is_leaflets_available,:string
  	add_column :requests,:is_wall_poster_in_shop,:string
  	add_column :requests,:is_dangler_in_shop,:string
  	add_column :requests,:rsp_assigned_in_store,:string
  	add_column :requests,:rsp_present_in_shop,:string
  	add_column :requests,:rsp_in_gionee_tshirt,:string
  	add_column :requests,:rsp_well_groomed,:string
  	add_column :requests,:rsp_selling_skills,:string
  	add_column :requests,:gsb_type_installed,:string
  	add_column :requests,:location_of_gsb,:string
  	add_column :requests,:gsb_cleanliness,:string
  	add_column :requests,:installation_quality,:string
  	add_column :requests,:is_gsb_light_woring,:string
  	add_column :requests,:is_gsb_light_throw_is_good,:string
  	add_column :requests,:gsb_structured_damage,:text
  	add_column :requests,:gsb_other_problem,:text
  	add_column :requests,:gsb_retailer_feedback,:string
  	add_column :requests,:is_sis_present,:string
  	add_column :requests,:is_sis_placed_properly,:string
  	add_column :requests,:is_sis_condition_good,:string
  	add_column :requests,:is_sis_cleaned_daily,:string
  	add_column :requests,:is_sis_damaged,:string
  	add_column :requests,:sis_structured_flaws,:string
  	add_column :requests,:sis_security_alarm_working,:string
  	add_column :requests,:sis_security_device_charging,:string
  	add_column :requests,:sis_demo_phones_installed,:string
  	add_column :requests,:spec_card_demo_phone_match,:string
  	add_column :requests,:backwall_light_working_properly,:string
  	add_column :requests,:is_counter_lights_working,:string
  	add_column :requests,:is_clip_on_lights,:string
  	add_column :requests,:dealer_switch_on_sis_lights,:string
  	add_column :requests,:updated_gionee_creative,:string
  	add_column :requests,:sis_any_problem,:text
  	add_column :requests,:sis_retailer_feedback,:text
  	add_column :requests,:is_good_visibility_in_store,:string
  	add_column :requests,:lit_in_store,:string
  	add_column :requests,:has_a_relevant_visual,:string
  	add_column :requests,:overall_rating,:string
  	add_column :requests,:overall_comments,:text
  	add_column :requests,:is_clipon_not_working_properly,:string
  	 


  end
end
