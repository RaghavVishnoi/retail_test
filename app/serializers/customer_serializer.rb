class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :website, :account_owner, :phone, :industry, :customer_group, :description, :phone1, :phone2, :email1, :email2, :licence_details, :created_at, :updated_at
  has_many :contacts
  has_many :orders
end