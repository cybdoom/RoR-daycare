class CreateTodoComments < ActiveRecord::Migration
  def change
    create_table :todo_comments do |t|
    	t.integer :occurrence_id
    	t.text :comment
    	t.integer :user_id
    	t.boolean :is_archived, default: false
      t.timestamps null: false
    end
  end
end
