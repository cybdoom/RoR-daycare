class AddDepartmentIdToUser < ActiveRecord::Migration
  def change
    add_reference :users, :department, index: true, foreign_key: true
    add_column :users, :username, :string
  end
end
