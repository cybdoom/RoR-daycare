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
  STATUS = %w(draft started ended)
  
  
  has_many :user_occurrences, dependent: :destroy

  belongs_to :todo

  validates :schedule_date, :due_date, presence: true, uniqueness: {scope: :todo_id}
  validate :correct_due_date
  # validate :correct_schedule_date
  validate :valid_status

  
  def next_schedule_date
    get_start_date(todo.recurring_rule, schedule_date)
  end

  def next_due_date
    get_end_date(todo.recurring_rule, schedule_date, due_date)
  end


  private
    def get_start_date(rule, date)
      if rule == "Every Day"
        date + 1.day
      elsif rule == "Every Week"
        date + 1.week
      elsif rule == "Every Other Week"
        date + 2.weeks 
      elsif rule == "Every Month"
        date + 1.month
      elsif rule == "Every 3 Months"
        date + 3.months
      elsif rule == "Every 6 Months"
        date + 6.months
      elsif rule == "Every Year"
        date + 1.year
      else
        nil
      end
    end

    def get_end_date(rule, s_date, e_date)
      next_schedule_date + (e_date - s_date)
    end

    # def correct_schedule_date
    #   if todo.occurrences.count > 1
    #     errors.add(:schedule_date, "must be greater than or equal #{todo.schedule_date} and less than #{todo.due_date}") if schedule_date < todo.schedule_date || schedule_date >= todo.due_date
    #   else
    #     previous_occurence = todo.occurrences.find(todo.occurrences.maximum(:id))
    #     errors.add(:schedule_date, "must be equal or might be greater than #{previous_occurence.next_schedule_date}") if schedule_date < previous_occurence.next_schedule_date || schedule_date >= previous_occurence.next_due_date
    #   end
    # end 

    def correct_due_date
      min_due_date = schedule_date + Todo.min_duration_between_schedule_and_due_dates
      min_duration_to_next_schedule = Todo.min_duration_before_next_schedule
      max_due_date = nil

      if todo.frequency == "One Time Event" && todo.recurring_rule == ""
        errors.add(:due_date, "must be greater than #{min_due_date}") if due_date <= min_due_date
      elsif todo.frequency == "Recurring Event" && Todo::RECURRANCE_OPTIONS.include?(todo.recurring_rule)
        if todo.recurring_rule == "Every Day"
          max_due_date = schedule_date + 1.day - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every Week"
          max_due_date = schedule_date + 1.week - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every Other Week"
          max_due_date = schedule_date + 2.week - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every Month"
          max_due_date = schedule_date + 1.month - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every 3 Months"
          max_due_date = schedule_date + 3.months - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every 6 Months"
          max_due_date = schedule_date + 6.months - min_duration_to_next_schedule
        elsif todo.recurring_rule == "Every Year"
          max_due_date = schedule_date + 1.year - min_duration_to_next_schedule
        else
          errors.add(:invalid_rule, "Please Select Correct recurring rule. Rule must be either one of following #{Todo::RECURRANCE_OPTIONS.join(', ')}") and return #unless Todo::RECURRANCE_OPTIONS.include?(todo.recurring_rule)
        end
        errors.add(:due_date, "must be between #{min_due_date} and  #{max_due_date}") if due_date < min_due_date || due_date > max_due_date

      else
        errors.add(:invalid_options, "Check your frequency and recurring_rule something is wrong")
      end
    end

    def valid_status
      errors.add(:occurrence_status, " must be one of #{STATUS.join(', ')}") unless STATUS.include?(status)
    end


end
