class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :city_id, :item_region_id, :category_id, :subcategory_id, :short_description, :details, :collection_id, :size_id, :alcohol_percent_id, :prices, :quantity, :unit_of_measurement
  has_many :images
end
