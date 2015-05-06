class ChangeRequestColumn < ActiveRecord::Migration
  def change
    remove_column :requests, :cmo_name
    add_column :requests, :cmo_id, :integer
    add_index :requests, :cmo_id
  end
end
