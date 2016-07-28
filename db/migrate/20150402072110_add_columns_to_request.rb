class AddColumnsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :approved_by_user_id, :integer
    add_column :requests, :declined_by_user_id, :integer
  end
end
