class Field < ActiveRecord::Base
  enum entity: ["Organization", "Region", "Item"]
  enum field_type: ["text", "dropdown"]
  enum value_type: ['string', 'decimal']
  
  serialize :configuration, Hash 

  validates :entity, :display_name, :presence => true

  has_many :field_values, :dependent => :destroy

  def self.with_entity(entity)
    where(:entity => entities[entity])
  end
end