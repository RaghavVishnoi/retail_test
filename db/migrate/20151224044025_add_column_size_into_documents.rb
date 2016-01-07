class AddColumnSizeIntoDocuments < ActiveRecord::Migration
  def change
  	add_column :documents, :file_size, :string
  end
end
