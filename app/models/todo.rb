# == Schema Information
#
# Table name: todos
#
#  id              :integer          not null, primary key
#  title           :string
#  schedule_date   :datetime
#  due_date        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_delegatable  :boolean          default(FALSE)
#  is_circulatable :boolean          default(FALSE)
#  todo_for        :string
#  status          :string           default("pending")
#  acceptor_id     :integer
#  daycare_id      :integer
#  frequency       :string
#  recurring_rule  :string
#  until           :datetime
#
# Indexes
#
#  index_todos_on_daycare_id  (daycare_id)
#

class Todo < ActiveRecord::Base
  FREQUENCY = %W(#{"One Time Event"} #{"Recurring Event"})
  RECURRANCE_OPTIONS = %W(#{"Every Day"} #{"Every Week"} #{"Every Other Week"} #{"Every Month"} #{"Every 3 Months"} #{"Every 6 Months"} #{"Every Year"} )
  # DAILY = %w(Sunday Monday Tuesday Wednesday Thrusday Friday Saturday)
  
  belongs_to :daycare
  has_many :key_tasks, dependent: :destroy
  has_many :department_todos, dependent: :destroy
  has_many :departments, through: :department_todos
  has_many :user_todos, dependent: :destroy
  has_many :users, through: :user_todos
  has_many :todo_managers, through: :user_todos, source: :manager
  has_many :todo_workers, through: :user_todos, source: :worker
  has_many :todo_parents, through: :user_todos, source: :parent
  # has_many :daycare_todos, dependent: :destroy
  # has_many :daycares, dependent: :destroy
  has_one :icon, as: :photoable, class_name: "Photo", dependent: :destroy
  #has_many :create_permissions#, as: :functionality
  has_many :occurrences

  belongs_to :acceptor, class_name: 'User', foreign_key: 'acceptor_id'

  validates :title, :schedule_date, :due_date, :daycare_id,  presence: true
  # validates :title, :schedule_date, :due_date, :todo_for, presence: true

  validate :valid_recurring_rule
  validate :correct_due_date
  validate :correct_schedule_date
  validate :delegatability #delegatable only if todo has one user

  accepts_nested_attributes_for :key_tasks, :occurrences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :icon, allow_destroy: true
  accepts_nested_attributes_for :user_todos, allow_destroy: true

  after_create :set_first_occurrence


  #Check permissions by user
  def can_be_created_by?(user)
    return true if user.superadmin?
    permission = user.daycare.create_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_edited_by?(user)
    return true if user.superadmin?
    permission = user.daycare.edit_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_viewed_by?(user)
    return true if user.superadmin?
    permission = user.daycare.view_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_reported_by?(user)
    return true if user.superadmin?
    permission = user.daycare.report_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def image(type = :medium)
    pic = icon.image.url(type) if icon
    pic = 'e_img1.jpg' if pic.blank?
    pic
  end


  def previous_occurrences
    occurrences.where("occurrences.due_date <= ?", DateTime.now)
  end

  def current_occurrence
    occurrences.where("occurrences.schedule_date <= ? AND occurrences.due_date > ?", DateTime.now, DateTime.now).last
  end

  def next_occurrence
    next_occurrences.first
  end

  def next_occurrences
    occurrences.where("occurrences.schedule_date >= ?", DateTime.now)
  end


  def save_user_todos(user_ids = [])
    user_ids.each do |user_id|
      if User.find(user_id)
        user_todo = self.user_todos.new(user_id: user_id) 
        user_todo.save
      end
    end
  end

  def save_user_occurrences(user_ids=[])
  end

  def self.min_duration_between_schedule_and_due_dates
    10.minutes
  end

  def self.min_duration_before_next_schedule
    10.minutes
  end

  def self.min_schedule_date
    DateTime.now + 5.hours
  end

  private 
    def valid_recurring_rule
      if frequency == "One Time Event"
        errors.add(:invalid_rule, "You cann't set recurring rule for One Time Event") unless recurring_rule == ""
      elsif frequency == "Recurring Event"
        errors.add(:invalid_rule, "Please Select Correct recurring rule. Rule must be either one of following #{RECURRANCE_OPTIONS.join(', ')}") unless RECURRANCE_OPTIONS.include?(recurring_rule)
      else
        errors.add(:invalid_frequency, "Frequency must be either One Time Event or Recurring Event")
      end
    end
    

    def correct_schedule_date
      errors.add(:schedule_date, "must be greater than #{Todo.min_schedule_date}") if schedule_date < Todo.min_schedule_date
    end 

    def correct_due_date
      min_due_date = schedule_date + Todo.min_duration_between_schedule_and_due_dates
      min_duration_to_next_schedule = Todo.min_duration_before_next_schedule
      max_due_date = nil


      if frequency == "One Time Event" && recurring_rule == ""
        errors.add(:due_date, "must be greater than #{min_due_date}") if due_date <= min_due_date
      elsif frequency == "Recurring Event" && RECURRANCE_OPTIONS.include?(recurring_rule)
        if recurring_rule == "Every Day"
          max_due_date = schedule_date + 1.day - min_duration_to_next_schedule
        elsif recurring_rule == "Every Week"
          max_due_date = schedule_date + 1.week - min_duration_to_next_schedule
        elsif recurring_rule == "Every Other Week"
          max_due_date = schedule_date + 2.week - min_duration_to_next_schedule
        elsif recurring_rule == "Every Month"
          max_due_date = schedule_date + 1.month - min_duration_to_next_schedule
        elsif recurring_rule == "Every 3 Months"
          max_due_date = schedule_date + 3.months - min_duration_to_next_schedule
        elsif recurring_rule == "Every 6 Months"
          max_due_date = schedule_date + 6.months - min_duration_to_next_schedule
        elsif recurring_rule == "Every Year"
          max_due_date = schedule_date + 1.year - min_duration_to_next_schedule
        else
          errors.add(:invalid_rule, "Please Select Correct recurring rule. Rule must be either one of following #{RECURRANCE_OPTIONS.join(', ')}") and return #unless RECURRANCE_OPTIONS.include?(recurring_rule)
        end        
        errors.add(:due_date, "must be between #{min_due_date} and  #{max_due_date}") if due_date < min_due_date || due_date > max_due_date
      else
        errors.add(:invalid_options, "Check your frequency and recurring_rule something is wrong")
      end
    end

    def set_first_occurrence
      self.occurrences.create(todo_id: id, schedule_date: schedule_date, due_date: due_date, status: :draft)
      save_user_occurrences(user_ids=[])
    end

    def delegatability
      errors.add(:delegatable_todo, "can have maximum one user") if self.is_delegatable? && UserTodo.where(todo_id: id).count > 1
    end

end
