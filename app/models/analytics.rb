class Analytics < ActiveRecord::Base
  databases = YAML.load_file("config/database_analytics.yml")
  establish_connection databases[Rails.env]
end