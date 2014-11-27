class Customer < ActiveRecord::Base
  validates :state, :inclusion => { :in => ADDRESS_STATES }
end