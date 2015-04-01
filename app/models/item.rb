class Item < ActiveRecord::Base
  include Fields
  
  belongs_to :city
  belongs_to :item_region
  belongs_to :category
  belongs_to :subcategory, :class_name => "Category"
  belongs_to :collection
  belongs_to :alcohol_percent
  belongs_to :size
  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :inventories, :dependent => :destroy
  has_many :documents, :dependent => :nullify

  validates :name, :presence => true

  serialize :details, Array
  serialize :prices, Array

  before_validation :reject_empty_serialized_attributes

  def self.with_name(name)
    if name.present?
      where("name like ?", "%#{name}%")
    else
      []
    end
  end

  private

    def reject_empty_serialized_attributes
      [:details, :prices].each do |column|
        self[column].reject! { |h| !h.values.any?(&:present?) }
      end
    end
end