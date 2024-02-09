class Task < ApplicationRecord
  validates :title, presence: true
  validates :status, inclusion: { in: %w(To Do In Progress Done) }
  validate :validate_todo_limit, if: :todo_status?

  def self.too_many_todo_tasks?(status)
    status == 'To Do' && where(status: 'To Do').count >= count / 2
  end

  private

  def validate_todo_limit
    errors.add(:status, 'Too many tasks in To Do status') if Task.too_many_todo_tasks?(status)
  end

  def todo_status?
    status == 'To Do'
  end
end
