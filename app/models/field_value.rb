class FieldValue < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :field

  def self.with_field_id(field_id)
    # where(:field_id => field_id).first
    select { |f| f.field_id == field_id }.first
  end
end