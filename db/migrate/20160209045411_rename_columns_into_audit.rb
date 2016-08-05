class RenameColumnsIntoAudit < ActiveRecord::Migration
  def change
  	rename_column :requests,:is_audit,:is_audit_done
  end
end
