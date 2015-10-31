# == Schema Information
#
# Table name: todo_comments
#
#  id            :integer          not null, primary key
#  occurrence_id :integer
#  comment       :text
#  user_id       :integer
#  is_archived   :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TodoComment < ActiveRecord::Base
	belongs_to :user
	belongs_to :occurrence

	validates :user_id, :occurrence_id, presence: true
end
