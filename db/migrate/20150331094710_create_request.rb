class CreateRequest < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :retailer_code
      t.string :rsp_name
      t.string :rsp_mobile_number
      t.string :rsp_app_user_id
      t.string :state
      t.string :city
      t.string :shop_name
      t.string :shop_address
      t.string :shop_owner_name
      t.string :shop_owner_phone
      t.boolean :is_main_signage
      t.boolean :is_sis_installed
      t.decimal :avg_store_monthly_sales, :precision => 10, :scale => 5
      t.decimal :avg_gionee_monthly_sales, :precision => 10, :scale => 5
      t.string :width
      t.string :height
      t.string :cmo_name
      t.string :request_type
      t.text :remarks
      t.timestamps
    end
  end
end
