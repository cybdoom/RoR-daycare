class DepartmentTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :department
end
