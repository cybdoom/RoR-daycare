class Todo < ActiveRecord::Base

  REPEAT_OPTIONS = %W(#{"One time event"} Weekly #{"Every month"} #{"Every 3 month"} #{"Every 6 month"} #{"Every year"} )
  DAILY = %w(Sunday Monday Tuesday Wednesday Thrusday Friday Saturday)
  
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

  belongs_to :acceptor, class_name: 'User', foreign_key: 'acceptor_id'

  validates :title, :schedule_date, :due_date, presence: true
  # validates :title, :schedule_date, :due_date, :todo_for, presence: true

  accepts_nested_attributes_for :key_tasks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :icon, allow_destroy: true

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

end
