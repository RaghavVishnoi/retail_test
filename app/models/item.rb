class Item < ActiveRecord::Base
  belongs_to :city
  belongs_to :item_region
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category"
  belongs_to :collection
  belongs_to :alcohol_percent
  has_many :images, :dependent => :destroy

  validates :name, :presence => true

  serialize :details, Array
  serialize :prices, Array

  before_validation :reject_empty_serialized_attributes

  private

    def reject_empty_serialized_attributes
      [:details, :prices].each do |column|
        self[column].reject! { |h| !h.values.any?(&:present?) }
      end
    end
end