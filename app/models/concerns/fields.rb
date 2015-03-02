module Fields
  extend ActiveSupport::Concern

  included do
    has_many :field_values, :as => :resource, :autosave => true
  end

  def properties=(args)
    args.values.each do |attrs|
      field_value = find_or_initialize_field_value(attrs[:field_id].to_i)
      field_value.value = attrs[:value]
    end
    args
  end

  def properties
    @properties = []
    unless @properties.present?
      Field.with_entity(self.class.name).each do |f|
        field_value = find_field_value(f.id)
        @properties << { :field => { :id => f.id, :display_name => f.display_name, :field_type => f.field_type, :value_type => f.value_type, :configuration => f.configuration }, :value => field_value.try(:value) }
      end
    end
    @properties
  end

  private
    def find_or_initialize_field_value(field_id)
      find_field_value(field_id) || initialize_field_value(field_id)
    end

    def find_field_value(field_id)
      field_values.select { |v| v.field_id == field_id }.first
    end

    def initialize_field_value(field_id)
      field_values.new :field_id => field_id
    end
end