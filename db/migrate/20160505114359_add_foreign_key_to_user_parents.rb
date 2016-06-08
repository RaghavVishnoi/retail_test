class AddForeignKeyToUserParents < ActiveRecord::Migration
  def change
  	add_index  :user_parents, :user_id
  	add_index  :user_parents, :user_id,name: :parent_id
  end
end
