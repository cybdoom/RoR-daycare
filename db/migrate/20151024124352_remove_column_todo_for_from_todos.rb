class RemoveColumnTodoForFromTodos < ActiveRecord::Migration
  def change
    remove_column :todos, :todo_for, :string
  end
end
