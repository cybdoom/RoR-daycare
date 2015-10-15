class UserTodo < ActiveRecord::Base
  belongs_to :manager, -> {where(type: 'Manager')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :worker, -> {where(type: 'Worker')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :parent, -> {where(type: 'Parent')}, foreign_key: 'user_id', class_name: 'User'
  belongs_to :todo
  belongs_to :user
end
