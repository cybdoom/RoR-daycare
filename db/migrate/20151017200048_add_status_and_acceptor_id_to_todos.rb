class AddStatusAndAcceptorIdToTodos < ActiveRecord::Migration
  def change
  	add_column :todos, :status, :string, default: "pending"
  	add_column :todos, :acceptor_id, :integer
  end
end
