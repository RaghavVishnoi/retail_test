class CreateBeatroute < ActiveRecord::Migration
  def change
    create_table :beatroutes do |t|
    	t.string :distributor_name
    	t.string :tsm_name
    	t.string :rsp_name
    	t.string :rsp_id
    	t.string :employee_code
    	t.string :shop_code
    	t.string :retailer_code
    	t.string :retailer_name
    	t.string :city
    	t.string :last_month_avg_sales_volume
    	t.string :last_month_avg_sales_value
        t.string :mtd_avg_sales_volume
    	t.string :mtd_avg_sales_value
    	t.string :avg_last_month_attendance
    	t.string :last_reported_stock
    	t.string :models_in_stock
    	t.string :distance_btwn_beatroute_and_app_location
    	t.string :sis_type
    	t.string :sis_installed_on
    	t.string :gsb_type
    	t.string :gsb_installed_on
    	t.string :clipon
    	t.string :countertop
    	t.string :flange
    	t.string :standee
    	t.string :inshop_branding
    	t.string :sis
    	t.string :gsb
    	t.timestamps
    end
  end
end
