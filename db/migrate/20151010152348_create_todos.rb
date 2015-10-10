class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string   :title
      t.datetime :schedule_date
      t.datetime :due_date
      t.belongs_to :daycare

      t.timestamps null: false
    end
  end
end
