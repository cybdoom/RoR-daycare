class CreateDaycareTodos < ActiveRecord::Migration
  def change
    create_table :daycare_todos do |t|
      t.belongs_to :todo, index: true, foreign_key: true
      t.belongs_to :daycare, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
