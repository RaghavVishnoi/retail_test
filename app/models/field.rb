class Field < ActiveRecord::Base
  enum entity: ["Organization", "Region", "Item", "Request"]
  enum field_type: ["text", "dropdown", "checkbox"]
  enum value_type: ['string', 'decimal']
  
  serialize :configuration, Hash 

  validates :entity, :display_name, :field_type, :presence => true

  has_many :field_values, :dependent => :destroy

  def self.with_entity(entity)
    where(:entity => entities[entity])
  end
end