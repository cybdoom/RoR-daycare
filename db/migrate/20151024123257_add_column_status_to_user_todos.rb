class AddColumnStatusToUserTodos < ActiveRecord::Migration
  def change
    add_column :user_todos, :status, :string
  end
end
