class AddColumnsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :space_available, :boolean
    add_column :requests, :is_gionee_gsb_present, :boolean
  end
end
