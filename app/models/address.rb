class Address < ActiveRecord::Base
  belongs_to :organization

  def self.hq
    find_or_create_by(:addressable_type => "hq")
  end

  def self.branch_offices
    where("addressable_type is null")
  end

  def text
    [address, city, state, country].join(', ')
  end
end