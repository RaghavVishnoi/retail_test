class RenameAssociatedState < ActiveRecord::Migration
  def change
  	   rename_table :associated_states, :user_states
  end
end
