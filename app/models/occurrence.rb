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
	STATUS = %w( draft started completed not_completed not_completed_in_time)
	belongs_to :todo
end
