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
#  status          :string           default("pending")
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


  validates :title, :schedule_date, :due_date, :daycare_id,  presence: true

  validate :valid_recurring_rule
  validate :correct_schedule_date, if: :schedule_date?
  validate :correct_due_date, if: [:schedule_date?, :due_date?]
  validate :delegatability #delegatable only if todo has one user
  validate :valid_user_todos_status


  accepts_nested_attributes_for :key_tasks, :occurrences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :icon, allow_destroy: true
  accepts_nested_attributes_for :user_todos, allow_destroy: true

  after_create :set_first_occurrence

  cron_job :set_todo_next_occurrence, interval: 6.hours

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
        user_todo.status  == self.is_circulatable? ? "inactive" :  "active" 
        user_todo.save
      end
    end
  end

  def min_schedule_date
    self.is_circulatable? ? DateTime.now : DateTime.now + 5.hours
  end
  
  def self.set_todo_next_occurrence
    todos = Todo.includes(:occurrences).where("todos.frequency != ? AND occurrences.schedule_date <= ? AND occurrences.due_date > ?", "One Time Event", DateTime.now, DateTime.now).references(:occurrences)
    todos.each do |todo|

      current_occurrence = todo.current_occurrence
      unless todo.next_occurrences.present?
        nxt_o = Occurrence.create(todo_id: todo.id, schedule_date: current_occurrence.next_schedule_date, due_date: current_occurrence.next_due_date, status: :draft)
        if nxt_o.present? && nxt_o.valid?
          nxt_o.save_user_occurrences(user_ids=todo.users.pluck(:id)) unless todo.is_circulatable?
          puts("Next Occurrence Created Successfully")
        else
          puts("Failed to create Next Occurrence")
          puts(nxt_o.errors.full_messages.join(", "))
        end
      end
    end
    logger.info "==============Cron Job Run At #{DateTime.now}==================="
  end

  def self.min_duration_between_schedule_and_due_dates
    10.minutes
  end

  def self.min_duration_before_next_schedule
    10.minutes
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
      errors.add(:schedule_date, "must be greater than #{self.min_schedule_date}") if schedule_date < self.min_schedule_date
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
      unless self.is_circulatable?
        o = self.occurrences.create(todo_id: id, schedule_date: schedule_date, due_date: due_date, status: :draft) 
        o.save_user_occurrences(user_ids = self.users.pluck(:id)) if o.valid?
      end
    end

    def delegatability
      errors.add(:delegatable_todo, "can have maximum one user") if self.is_delegatable? && UserTodo.where(todo_id: id).count > 1
    end

    def valid_user_todos_status
      self.user_todos.each do |ut| 
        if self.is_circulatable?
          errors.add(:user_todo_status, " must be inactive for circulatable todos unless it is accepted by a user first") if ut.new_record? && ut.status == "active"
        else
          errors.add(:user_todo_status, " must be active as it is not a circulatable") if ut.status ==  "inactive"
        end
      end        
    end
end
