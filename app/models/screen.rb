class Screen < ActiveRecord::Base
  serialize :layout, Hash
end