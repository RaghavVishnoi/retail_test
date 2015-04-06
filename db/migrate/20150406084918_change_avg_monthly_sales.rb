class ChangeAvgMonthlySales < ActiveRecord::Migration
  def change
    change_column :requests, :avg_store_monthly_sales, :decimal, :precision => 10, :scale => 2
    change_column :requests, :avg_gionee_monthly_sales, :decimal, :precision => 10, :scale => 2
  end
end
