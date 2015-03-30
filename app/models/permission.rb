class Permission < ActiveRecord::Base
  ACTIONS = ["manage", "create", "update", "read", "destroy"]
  SUBJECT_CLASS = ["all", "Customer", "UsersReporting", "Attendance"]

  belongs_to :role

  validates :action, :inclusion => { :in => ACTIONS }
  validates :subject_class, :inclusion => { :in => SUBJECT_CLASS }
end