class ChangeColumnInRequestActivities < ActiveRecord::Migration
  def change
  	#change_column :request_documents,:request_document_id,:integer
  	change_column :request_documents, :request_document_id, 'integer USING CAST(request_document_id AS integer)'
  end
end
