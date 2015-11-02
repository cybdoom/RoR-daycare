# == Schema Information
#
# Table name: user_occurrences
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  occurrence_id :integer
#  todo_status   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  delegatee_id  :integer
#

class UserOccurrence < ActiveRecord::Base
  TODO_STATUS = %w( draft assigned completed not_completed not_completed_in_time)

  belongs_to :user
  belongs_to :occurrence
  # belongs_to :delegatee, class_name: "User", foreign_key: "delegatee_id"

  validates :user_id, :occurrence_id, presence: true
  validates_uniqueness_of :user_id, scope: :occurrence_id
  validate :valid_todo_status

  def performer
    User.find(delegatee_id || user_id)
  end

  def mark_as_completed
    self.todo_status = :completed
    if self.save
      return true
    else
      return false
    end
  end

  def mark_as_not_applicable#comments, user_id)
    
    # self.todo_status = :not_completed
    # if self.save
    #   return true
    # else
    #   return false
    # end
  end

  private
  def valid_todo_status
    errors.add(:todo_status, "must be one of #{TODO_STATUS.join(', ')}")  unless TODO_STATUS.include?(todo_status)
  end


end
