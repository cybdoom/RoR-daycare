# == Schema Information
#
# Table name: occurrences
#
#  id            :integer          not null, primary key
#  todo_id       :integer
#  schedule_date :datetime
#  due_date      :datetime
#  status        :string
#  submitted_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_occurrences_on_todo_id  (todo_id)
#

class Occurrence < ActiveRecord::Base
	STATUS = %W( Draft Started Completed #{"Not Completed"} #{"Not Completed in Time"})
	belongs_to :todo
end
