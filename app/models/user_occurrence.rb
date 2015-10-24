# == Schema Information
#
# Table name: user_occurrences
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  occurrence_id     :integer
#  delegated_user_id :integer
#  todo_status       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class UserOccurrence < ActiveRecord::Base
  TODO_STATUS = %w( draft accepted completed not_completed not_completed_in_time)

  validates :user_id, :occurrence_id, presence: true
  validates_uniqueness_of :user_id, scope: :occurrence_id
  validate :valid_todo_status

  def doer
    User.find(delegated_user_id || user_id)
  end

  private
  def valid_todo_status
    errors.add(:todo_status, " must be one of #{TODO_STATUS.join(', ')}")
  end
end
