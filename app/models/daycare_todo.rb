# == Schema Information
#
# Table name: daycare_todos
#
#  id         :integer          not null, primary key
#  todo_id    :integer
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_daycare_todos_on_daycare_id  (daycare_id)
#  index_daycare_todos_on_todo_id     (todo_id)
#

class DaycareTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :daycare
end
