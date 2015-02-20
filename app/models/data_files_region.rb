class DataFilesRegion < ActiveRecord::Base
  belongs_to :data_file
  belongs_to :region
end