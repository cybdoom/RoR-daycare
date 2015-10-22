class CreateUserOccurrences < ActiveRecord::Migration
  def change
    create_table :user_occurrences do |t|
      t.belongs_to :user
      t.belongs_to :occurrence
      t.belongs_to :todo_status
      t.timestamps null: false
    end
  end
end
