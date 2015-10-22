class CreateUserOccurrences < ActiveRecord::Migration
  def change
    create_table :user_occurrences do |t|
      t.belongs_to :user
      t.belongs_to :occurrence

      t.integer :delegated_user_id
      t.string :todo_status
      
      t.timestamps null: false
    end
  end
end
