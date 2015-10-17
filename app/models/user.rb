class User < ActiveRecord::Base
  belongs_to :daycare
  belongs_to :role
  has_many :user_todos, dependent: :destroy
  has_many :todos, through: :user_todos
  has_many :accepted_todos, class_name: 'Todo', foreign_key: 'acceptor_id'
  # has_many :owned_todos, class_name: "Todo", foreign_key: "owner_id"
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def all_todos
    self.todos.where("start_date <= ?", DateTime.now).where.not("acceptor_id != ? AND status = ?", self.id, "accepted")
    # Todo.all
  end

  def superadmin?
  	role and role.name.eql?('superadmin')
  end

  def manager?
  	type.eql?('Manager')
  end

  def worker?
    type.eql?('Worker')
  end

  def parent?
    type.eql?('Parent')
  end

  # Check permissions
  def can_create?(functionality)
    return true if superadmin?
    permission = daycare.create_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end

  def can_edit?(functionality)
    return true if superadmin?
    permission = daycare.edit_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end

  def can_view?(functionality)
    return true if superadmin?
    if can_create?(functionality) || can_edit?(functionality) || can_report?(functionality)
      true
    else
      permission = daycare.view_permissions.find_by(functionality_type: functionality, user_type: self.type)
      permission ? true : false
    end
  end

  def can_report?(functionality)
    return true if superadmin?
    permission = daycare.report_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end
end
