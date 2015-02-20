class Document < DataFile
  belongs_to :item
  
  validates :data_file, :presence => true
end