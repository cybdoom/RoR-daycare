class AddScheduleColumnsToTodos < ActiveRecord::Migration
  def change
  	add_column :todos, :frequency, :string
  	add_column :todos, :recurring_rule, :string
  	add_column :todos, :until, :datetime
  end
end
