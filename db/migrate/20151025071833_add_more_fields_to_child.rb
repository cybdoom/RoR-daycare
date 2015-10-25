class AddMoreFieldsToChild < ActiveRecord::Migration
  def change
  	remove_column :children, :daycare_id, :integer
  	add_column :children, :parent_id, :integer
  	add_column :children, :birth_year, :string
  	add_column :children, :department_id, :integer
  end
end
