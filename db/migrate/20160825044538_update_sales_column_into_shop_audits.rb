class UpdateSalesColumnIntoShopAudits < ActiveRecord::Migration
  def change
  	rename_column :shop_audits,:avg_monthly_sale,:average_monthly_sales
  	rename_column :shop_audits,:most_selling_brand ,:most_selling_brand
  	rename_column :shop_audits,:second_most_selling_brand ,:second_most_selling_brand
  	rename_column :shop_audits,:third_most_selling_brand ,:third_most_selling_brand
  	rename_column :shop_audits,:gionee_sales ,:gionee_sales
  	rename_column :shop_audits,:gionee_stock_quantity ,:gionee_stock_quantity
  	rename_column :shop_audits,:models_available ,:models_available
  end
end
