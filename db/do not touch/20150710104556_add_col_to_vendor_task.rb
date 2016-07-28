class AddColToVendorTask < ActiveRecord::Migration
  def change
  	add_column :vendor_tasks, :status, :string
  	add_column :vendor_tasks, :approver_id, :string
  	add_column :vendor_tasks, :approver_name,:string
  	add_column :vendor_tasks, :approver_comment,:text
  	add_column :vendor_tasks, :approver_approve_date, :string
  	add_column :vendor_tasks, :cmo_comment, :text
  	add_column :vendor_tasks, :cmo_approve_date, :string

  end
end
