class ChangeColumnNameInVendorTasks < ActiveRecord::Migration
  def change
  	rename_column :vendor_tasks, :approver_comment, :comment_by_approver
  	rename_column :vendor_tasks, :cmo_comment, :comment_by_cmo
  end
end
