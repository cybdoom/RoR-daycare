class Todo < ActiveRecord::Base
  belongs_to :daycare
  has_many :key_tasks
  has_many :department_todos, dependent: :destroy
  has_many :departments, through: :department_todos, dependent: :destroy

  validates :title, :schedule_date, :due_date, presence: true

  accepts_nested_attributes_for :key_tasks, allow_destroy: true, reject_if: :all_blank
end
