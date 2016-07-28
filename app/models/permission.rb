class Permission < ActiveRecord::Base

  belongs_to :role

  validates :action, :subject_class, :presence => true

  def action_permission=(val)
    self.action, self.subject_class = val.split(',').map(&:strip)
    @action_permission = val
  end

  def action_permission
    @action_permission ||= [action, subject_class].join(', ')
  end
end