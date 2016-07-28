class AddColumnsIntoAudit < ActiveRecord::Migration
  def change
  	add_column :requests,:is_audit,:boolean
  	add_column :requests,:store_open,:string
  	add_column :requests,:store_renovation,:string
  	add_column :requests,:store_shifted,:string
  	add_column :requests,:not_allowed_in_store,:string
  end
end
