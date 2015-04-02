class AddStatusToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :status, :string
    add_index :requests, :status
  end
end
