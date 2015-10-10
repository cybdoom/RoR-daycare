class KeyTask < ActiveRecord::Base
  has_many :sub_tasks, foreign_key: 'key_task_id', class_name: 'KeyTask'
  belongs_to :key_task
  belongs_to :todo

  validates :name, presence: true

  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, reject_if: :all_blank
end
