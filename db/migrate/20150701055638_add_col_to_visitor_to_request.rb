class AddColToVisitorToRequest < ActiveRecord::Migration
  def change

  	add_column :requests,:overall_comments,:text
  end
end
