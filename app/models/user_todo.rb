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
 
  belongs_to :manager, -> {where(type: 'Manager')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :worker, -> {where(type: 'Worker')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :parent, -> {where(type: 'Parent')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :todo
  belongs_to :user

  validates :user_id, :todo_id, presence: true
  validates_uniqueness_of :user_id, scope: :todo_id
  validate :delegatability #delegatable only if todo has one user

  private
  def delegatability
  	errors.add(:delegatable_todo, "can have maximum one user") if todo.is_delegatable? && UserTodo.find_by(todo_id: todo_id)
  end
end
