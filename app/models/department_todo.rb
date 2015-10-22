# == Schema Information
#
# Table name: department_todos
#
#  id            :integer          not null, primary key
#  todo_id       :integer
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_department_todos_on_department_id  (department_id)
#  index_department_todos_on_todo_id        (todo_id)
#
# Foreign Keys
#
#  fk_rails_26d45f9efc  (department_id => departments.id)
#  fk_rails_fcbf040d3a  (todo_id => todos.id)
#

class DepartmentTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :department
end
