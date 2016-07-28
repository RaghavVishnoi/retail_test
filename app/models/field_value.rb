class FieldValue < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :field
end