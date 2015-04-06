class ChangeRequestTypeToInteger < ActiveRecord::Migration
  def change
    change_column :requests, :request_type, :integer
    add_index :requests, :request_type
  end
end
