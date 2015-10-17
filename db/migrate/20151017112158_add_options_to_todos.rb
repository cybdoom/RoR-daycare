class AddOptionsToTodos < ActiveRecord::Migration
  def change
  	add_column :todos, :is_delegatable, :boolean, default: false 
  	add_column :todos, :is_circulatable, :boolean, default: false 
  	add_column :todos, :todo_for, :string
  end
end
