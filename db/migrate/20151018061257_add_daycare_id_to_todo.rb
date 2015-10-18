class AddDaycareIdToTodo < ActiveRecord::Migration
  def change
    add_reference :todos, :daycare, index: true, foreign_key: true
  end
end
