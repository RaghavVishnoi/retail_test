class UpdateSalesColumnIntoShopAudits < ActiveRecord::Migration
  def change
  	rename_column :shop_audits,:avg_monthly_sale,:average_monthly_sales
  end
end
