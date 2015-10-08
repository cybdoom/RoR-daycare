class Daycare < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :departments

  accepts_nested_attributes_for :users, :departments, allow_destroy: true, reject_if: :all_blank
  
  after_create :set_role

  #Set Admin role to primary user-------------------
  def set_role
    role = self.roles.find_or_create_by(name: 'manager')
    if users.last.present?
      self.users.last.update(role_id: role.id, daycare_id: id)
    end
  end

  #Daycare manager based on manager role-----------
  def daycare_manager
    if users.present?
      role = roles.find_by(name: 'manager')
      manager = users.find_by(role_id: role.id)
      return manager
    else
      return nil
    end
  end
end
