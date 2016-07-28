class AddStatusFromSalesOrder < ActiveRecord::Migration
  def change
  	add_column :sales_orders,:status,:string,:default => 'pending'
  end
end
