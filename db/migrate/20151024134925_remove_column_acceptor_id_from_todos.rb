class RemoveColumnAcceptorIdFromTodos < ActiveRecord::Migration
  def change
    remove_column :todos, :acceptor_id, :integer
  end
end
