class Customer < ActiveRecord::Base
  has_many :customers_users, :dependent => :destroy
  has_many :users, :through => :customers_users
  has_many :contacts, :dependent => :destroy
  has_many :orders

  validates :name, :presence => true
  
  def self.with_name(name)
    if name.present?
      where("name like ?", "%#{name}%")
    else
      []
    end
  end
end