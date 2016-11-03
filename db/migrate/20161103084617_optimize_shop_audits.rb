class OptimizeShopAudits < ActiveRecord::Migration
  def change
  	change_column :shop_audits,:audit_type,:integer,limit: 2
  	change_column :shop_audits,:average_monthly_sales,:string,limit: 15
  	change_column :shop_audits,:most_selling_brand,:string,limit: 50
  	change_column :shop_audits,:second_most_selling_brand,:string,limit: 50
  	change_column :shop_audits,:third_most_selling_brand,:string,limit: 50
  	change_column :shop_audits,:gionee_sales,:string,limit: 50
  	change_column :shop_audits,:gionee_stock_quantity,:string,limit: 50
  	change_column :shop_audits,:flange_condition,:string,limit: 50
  	change_column :shop_audits,:lit_standee_condition,:string,limit: 50
  	change_column :shop_audits,:demo_condition,:string,limit: 50
  	change_column :shop_audits,:dummy_condition,:string,limit: 50
  	change_column :shop_audits,:countertop_condition,:string,limit: 50
  	change_column :shop_audits,:clipon_condition,:string,limit: 50
  	change_column :shop_audits,:maintenance_done_on,:string,limit: 20
  	change_column :shop_audits,:type_of_issue,:string,limit: 100
  	change_column :shop_audits,:sis_type,:string,limit: 100
  	change_column :shop_audits,:sis_condition,:string,limit: 100
  	change_column :shop_audits,:sis_needs,:string,limit: 100
  	change_column :shop_audits,:gsb_type_installed,:string,limit: 50
  	change_column :shop_audits,:gsb_type_logo,:string,limit: 100
  	change_column :shop_audits,:gsb_position,:string,limit: 100
  	change_column :shop_audits,:gsb_condition,:string,limit: 100
  	change_column :shop_audits,:gsb_size,:string,limit: 100
  	change_column :shop_audits,:no_of_range_brochure,:string,limit: 20
  	change_column :shop_audits,:range_brochure_type,:string,limit: 50
  	change_column :shop_audits,:leaflet_type,:string,limit: 50
  	change_column :shop_audits,:poster_type,:string,limit: 50
  	change_column :shop_audits,:no_of_wall_branding,:string,limit: 20
  	change_column :shop_audits,:wall_branding_type,:string,limit: 50
  	change_column :shop_audits,:no_of_one_way_vision,:string,limit: 10
  	change_column :shop_audits,:one_way_vision_type,:string,limit: 50
  	change_column :shop_audits,:no_of_danglers,:string,limit: 10
  	change_column :shop_audits,:danglers_type,:string,limit: 50
  	change_column :shop_audits,:no_of_shelf_strips,:string,limit: 10
  	change_column :shop_audits,:shelf_strips_type,:string,limit: 50
  	change_column :shop_audits,:no_of_roll_up_standee,:string,limit: 10
   	change_column :shop_audits,:roll_up_standee_type,:string,limit: 50
  end
end
