class CreateRequestDocuments < ActiveRecord::Migration
  def change
    create_table :request_documents do |t|
    	t.string :request_document
    	t.string :request_document_id
    	t.string :request_document_type
    	t.timestamps
    end
  end
end
