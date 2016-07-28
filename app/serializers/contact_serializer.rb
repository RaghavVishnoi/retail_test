class ContactSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :designation, :avatar_url, :phone, :created_at, :updated_at
end