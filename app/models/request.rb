class Request < ActiveRecord::Base
  include Fields

  has_many :images, :as => :imageable, :dependent => :destroy
end