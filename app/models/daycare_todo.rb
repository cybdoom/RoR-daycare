class DaycareTodo < ActiveRecord::Base
  belongs_to :todo
  belongs_to :daycare
end
