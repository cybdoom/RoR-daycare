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

class KeyTask < ActiveRecord::Base
  has_many :sub_tasks, foreign_key: 'key_task_id', class_name: 'KeyTask'
  belongs_to :key_task
  belongs_to :todo

  validates :name, presence: true

  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, reject_if: :all_blank
end
