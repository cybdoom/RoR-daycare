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
end
