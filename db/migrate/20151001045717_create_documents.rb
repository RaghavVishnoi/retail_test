class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
    	t.string :document_name
    	t.datetime :uploaded_date
    	t.timestamps
    end
  end
end
