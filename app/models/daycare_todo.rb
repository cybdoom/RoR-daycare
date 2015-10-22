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
# Foreign Keys
#
#  fk_rails_5548e1faf5  (todo_id => todos.id)
#  fk_rails_5e318e72db  (daycare_id => daycares.id)
#

class DaycareTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :daycare
end
