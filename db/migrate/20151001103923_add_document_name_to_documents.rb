class AddDocumentNameToDocuments < ActiveRecord::Migration
  def change
  	add_column :documents, :document_name, :string
  end
end
