class ChangeColumnsRequests < ActiveRecord::Migration
  def change
    add_column :requests, :is_rsp, :boolean
    add_column :requests, :rsp_not_present_reason, :string
    remove_column :requests, :space_available
    remove_column :requests, :width
    remove_column :requests, :height
  end
end
