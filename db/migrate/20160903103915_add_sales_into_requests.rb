class AddSalesIntoRequests < ActiveRecord::Migration
  def change
  	add_column :requests,:average_monthly_sales,:string
    add_column :requests,:most_selling_brand,:string
    add_column :requests,:second_most_selling_brand,:string 
    add_column :requests,:third_most_selling_brand,:string
    add_column :requests,:gionee_sales,:string
    add_column :requests,:gionee_stock_quantity,:string
    add_column :requests,:models_available,:string  
  end
end
