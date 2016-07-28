class DataFilesUser < ActiveRecord::Base
  belongs_to :data_file
  belongs_to :user
end