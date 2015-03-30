class RemoveRolesFromDataFiles < ActiveRecord::Migration
  def change
    remove_column :data_files, :roles_mask
  end
end
