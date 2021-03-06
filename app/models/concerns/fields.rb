module Fields
  extend ActiveSupport::Concern

  included do
    has_many :field_values, :as => :resource, :autosave => true, :dependent => :destroy
  end

  def properties=(args)
    args.values.each do |attrs|
      [attrs[:value], attrs[:values]].flatten.compact.each do |val| 
        field_value = initialize_field_value(attrs[:field_id].to_i)
        field_value.value = val
      end
    end
    @values = {}
    args
  end

  def properties
    unless @properties.present?
      @properties = []
      Field.with_entity(self.class.name).each do |f|
        values = find_field_values(f.id).map(&:value)
        @properties << { :field => { :id => f.id, :display_name => f.display_name, :field_type => f.field_type, :value_type => f.value_type, :mandatory => f.mandatory, :configuration => f.configuration }, :values => values }
      end
    end
    @properties
  end

  private

    def find_field_values(field_id)
      @values ||= {}
      @values[field_id] ||= field_values.select { |v| v.field_id == field_id && !v.marked_for_destruction? }
    end

    def initialize_field_value(field_id)
      find_field_values(field_id).each &:mark_for_destruction
      field_values.new :field_id => field_id
    end
end