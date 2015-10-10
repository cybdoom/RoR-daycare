class CreateKeyTasks < ActiveRecord::Migration
  def change
    create_table :key_tasks do |t|
      t.string :name
      t.belongs_to :key_task, index: true, foreign_key: true
      t.belongs_to :todo, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
