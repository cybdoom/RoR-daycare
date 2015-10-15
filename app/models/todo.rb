class Todo < ActiveRecord::Base
  belongs_to :daycare
  has_many :key_tasks, dependent: :destroy
  has_many :department_todos, dependent: :destroy
  has_many :departments, through: :department_todos
  has_many :user_todos, dependent: :destroy
  has_many :users, through: :user_todos
  has_many :todo_managers, through: :user_todos, source: :manager
  has_many :todo_workers, through: :user_todos, source: :worker
  has_many :todo_parents, through: :user_todos, source: :parent
  has_one :icon, as: :photoable, class_name: "Photo", dependent: :destroy
  #has_many :create_permissions#, as: :functionality

  validates :title, :schedule_date, :due_date, presence: true

  accepts_nested_attributes_for :key_tasks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :icon, allow_destroy: true

  #Check permissions by user
  def can_be_created_by?(user)
    permission = user.daycare.create_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_edited_by?(user)
    permission = user.daycare.edit_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_viewed_by?(user)
    permission = user.daycare.view_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def can_be_reported_by?(user)
    permission = user.daycare.report_permissions.find_by(functionality_type: self.class.name, user_type: user.type)
    permission ? true : false
  end

  def image(type = :medium)
    pic = icon.image.url(type) if icon
    pic = 'e_img1.jpg' if pic.blank?
    pic
  end

end
