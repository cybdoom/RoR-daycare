class RemoveDaycareIdFromTodo < ActiveRecord::Migration
  def change
    remove_column :todos, :daycare_id, :integer
  end
end
