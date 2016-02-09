class ChangeColumnIsAuditDone < ActiveRecord::Migration
  def change
  	change_column :requests, :is_audit_done, :boolean, :default => true
  end
end
