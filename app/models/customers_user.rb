class CustomersUser < ActiveRecord::Base
  belongs_to :customer
  belongs_to :user

  validates :customer, :user, :presence => true
  validates :user_id, :uniqueness => { :scope => :customer_id }

  def self.with_customer_id(customer_id)
    customer_id.present? ? where(:customer_id => customer_id) : []
  end

  def accessible_by?(user)
    new_record? || (user.users_reportings.with_reporting_user_id(user_id).first && user.customers_users.with_customer_id(customer_id).first)
  end
end