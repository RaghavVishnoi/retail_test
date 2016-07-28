class AddColmToRequests < ActiveRecord::Migration
  def change

  	add_column :requests,:comment_by_cmo,:text
  end
end
