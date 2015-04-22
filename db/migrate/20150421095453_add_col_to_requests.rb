class AddColToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :is_gsb_installed_outside, :boolean
  end
end
