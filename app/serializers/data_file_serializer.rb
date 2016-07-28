class DataFileSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :type, :data_file_url, :user_ids, :region_ids, :role_ids, :sharable
  
  def data_file_url
    object.data_file_url
  end
end