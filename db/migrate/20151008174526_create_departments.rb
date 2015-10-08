class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :department_name
      t.belongs_to :daycare, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
