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

class DaycareTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :daycare
end
