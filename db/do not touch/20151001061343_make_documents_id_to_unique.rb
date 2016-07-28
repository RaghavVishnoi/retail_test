class MakeDocumentsIdToUnique < ActiveRecord::Migration
  def change
  	change_column :repositories, :documents_id, :integer, unique:  true
  end
end
