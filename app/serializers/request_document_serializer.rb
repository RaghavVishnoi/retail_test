class RequestDocumentSerializer < ActiveModel::Serializer
  attributes :id, :request_document_url

  def request_document_url
    object.request_document_url
  end
end
