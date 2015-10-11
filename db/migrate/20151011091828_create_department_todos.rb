class CreateDepartmentTodos < ActiveRecord::Migration
  def change
    create_table :department_todos do |t|
      t.belongs_to :todo, index: true, foreign_key: true
      t.belongs_to :department, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
