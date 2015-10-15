class User < ActiveRecord::Base
  belongs_to :daycare
  belongs_to :role
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
    permission = daycare.create_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end

  def can_edit?(functionality)
    permission = daycare.edit_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end

  def can_view?(functionality)
    if can_create?(functionality) || can_edit?(functionality) || can_report?(functionality)
      true
    else
      permission = daycare.view_permissions.find_by(functionality_type: functionality, user_type: self.type)
      permission ? true : false
    end
  end

  def can_report?(functionality)
    permission = daycare.report_permissions.find_by(functionality_type: functionality, user_type: self.type)
    permission ? true : false
  end
end
