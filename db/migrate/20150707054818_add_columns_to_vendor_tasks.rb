class AddColumnsToVendorTasks < ActiveRecord::Migration
  def change
  	add_column :vendor_tasks, :requestor_type, :string
  	add_column :vendor_tasks, :vendor_id, :integer
  	add_column :vendor_tasks, :other_identity, :string
  	add_column :vendor_tasks, :installation_of, :string
  	add_column :vendor_tasks, :installation_report, :string

  end
end
