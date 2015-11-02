# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  role_id                :integer
#  daycare_id             :integer
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  type                   :string
#  name                   :string
#  set_password_token     :string
#  api_key                :string
#  department_id          :integer
#  username               :string
#
# Indexes
#
#  index_users_on_department_id         (department_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  belongs_to :daycare
  belongs_to :role
  has_many :user_todos, dependent: :destroy
  has_many :user_occurrences, dependent: :destroy
  has_many :todos, ->{where("user_todos.status = ?", :active)},  through: :user_todos
  has_many :inactive_todos, ->{where("user_todos.status = ?", :inactive)},  through: :user_todos, source: :todo
  # has_many :active_todos, ->{where("user_todos.status = ?", :active)},  through: :user_todos, source: :todo

  has_many :todo_comments, ->{where(is_archived: true)}
  # has_many :delegated_todos, ->{where {"todos.delegatee_id"}}
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  
  before_create { generate_token(:set_password_token) }
  before_create { generate_token(:api_key) }
  

  def all_non_dued_todos

    #user_todos not circulatable
    #user todos circulatable_todos not not accepted
    #user todos circulatable_todos and accepted by self only
    #delegated to me todos

    #filter
    #current_occurrences

    my_todos = todos.includes(:occurrences).where("occurrences.schedule_date <= ? AND occurrences.due_date > ?", DateTime.now, DateTime.now).references(:occurrences)

    delegatee_todos = []
    # delegatee_todos = daycare.todos.includes(users: :user_occurrences).where("user_occurrences.user_id != ? AND user_occurrences.delegatee_id = ? AND todos.schedule_date <= ? AND todos.due_date > ?", id, id, DateTime.now, DateTime.now).references(:user_occurrences)

    circulatable_todos = daycare.todos.includes(users: :user_todos).where("user_todos.user_id = ? AND user_todos.status = ? AND todos.schedule_date <= ? AND todos.due_date > ?", id, "inactive", DateTime.now, DateTime.now).references(:user_todos)

    # ==========================================================

    # self.todos.where("schedule_date <= ?", DateTime.now).where.not("acceptor_id != ? AND status = ?", self.id, "accepted")
    # Todo.all
   

    # my_todos = self.todos
    # my_todos = my_todos.includes(:occurrences).where("occurrences.schedule_date <= ? AND occurrences.due_date > ?", DateTime.now, DateTime.now).references(:occurrences)
    # delegated_to_me_todos = Todo.includes(:user_todos, :occurrences).where.not("user_todos.user_id != ? ", id).where("occurrences.schedule_date <= ? AND occurrences.due_date > ?", DateTime.now, DateTime.now).references(:user_todos).references(:occurrences)

    my_todos + delegatee_todos + circulatable_todos
  end

  def all_dued_todos
  end

  def superadmin?
  	role.present? and role.name.eql?('superadmin')
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

  class << self
    def authentication_user_with_login_parameters(login, password, role)
      user, error_msg = nil, nil
      error_msg = "Username can't be blank" unless login.present?
      error_msg = "Password can't be blank" unless password.present?
      error_msg = "Role can't be blank" unless role.present?
      if login.present? && password.present? && role.present?
        if role == "superadmin"
          # user = User.joins(:role).where("roles.name = ?", "superadmin").with_username_or_email(login).first
          error_msg =  "API Not Available for superadmin login"
        elsif role == "manager"
          user = Manager.with_username_or_email(login).first
        elsif role == "parent"
          user = Parent.with_username_or_email(login).first
        elsif role == "worker"
          user = Worker.with_username_or_email(login).first
        else
          error_msg = "Invalid Role Provided"
        end
        if user.present?
          if user.valid_password?(password)
            user.generate_token(:api_key) and user.save!(validate: false) if user.api_key.blank?
          else
            error_msg = "Password is invalid"
          end
        else
          error_msg ||= "No user found"
        end
      end
      return user, error_msg
    end

    # def with_email_and_api_key(email, api_key)
    #   with_email(email).with_api_key(api_key).first
    # end

    # def with_username_and_api_key(username, api_key)
    #   with_username(username).with_api_key(api_key).first
    # end

    def with_username_or_email(login)
      where("email = ?", login)
    end
  end


  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while(User.find_by(column => self[column]).present?)
  end

  private
end
