class RemoveStatusFromSalesOrder < ActiveRecord::Migration
  def change
  	remove_column :sales_orders,:status
  end
end
