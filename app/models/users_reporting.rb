class UsersReporting < ActiveRecord::Base
  has_many :attendances, :primary_key => :reporting_user_id, :foreign_key => :user_id
  belongs_to :reporting_user, :class_name => "User"
  belongs_to :report_to_user, :class_name => "User"

  def self.with_reporting_user_id(user_id)
    user_id.present? ? where(:reporting_user_id => user_id) : []
  end
end