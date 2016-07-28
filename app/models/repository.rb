class Repository < ActiveRecord::Base

 belongs_to :users, :class_name => 'User'
 belongs_to :tags, :class_name => 'Tag'
 belongs_to :documents, :class_name => 'Document'
 belongs_to :levels, :class_name => 'Level'

end
