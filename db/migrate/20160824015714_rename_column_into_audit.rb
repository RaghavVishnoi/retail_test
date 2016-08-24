class RenameColumnIntoAudit < ActiveRecord::Migration
  def change
  	rename_column :shop_audits,:escalate_to_tl,:escalate
  end
end
