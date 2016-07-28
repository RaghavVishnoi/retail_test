class RemoveActiveFromModuleGroup < ActiveRecord::Migration
  def change
    remove_column :module_groups, :active
  end
end
