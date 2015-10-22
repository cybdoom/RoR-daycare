# == Schema Information
#
# Table name: user_occurrences
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  occurrence_id  :integer
#  todo_status_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class UserOccurrence < ActiveRecord::Base
end
