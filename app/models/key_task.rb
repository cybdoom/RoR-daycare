# == Schema Information
#
# Table name: key_tasks
#
#  id          :integer          not null, primary key
#  name        :string
#  key_task_id :integer
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_key_tasks_on_key_task_id  (key_task_id)
#  index_key_tasks_on_todo_id      (todo_id)
#
# Foreign Keys
#
#  fk_rails_0077ea7e18  (key_task_id => key_tasks.id)
#  fk_rails_c57449873d  (todo_id => todos.id)
#

class KeyTask < ActiveRecord::Base
  has_many :sub_tasks, foreign_key: 'key_task_id', class_name: 'KeyTask'
  belongs_to :key_task
  belongs_to :todo

  validates :name, presence: true

  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, reject_if: :all_blank
end
