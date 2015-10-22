# == Schema Information
#
# Table name: user_todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_todos_on_todo_id  (todo_id)
#  index_user_todos_on_user_id  (user_id)
#

class UserTodo < ActiveRecord::Base
  # TODO_STATUS = %w( draft started completed not_completed not_completed_in_time)

  belongs_to :manager, -> {where(type: 'Manager')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :worker, -> {where(type: 'Worker')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :parent, -> {where(type: 'Parent')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :todo
  belongs_to :user
end
