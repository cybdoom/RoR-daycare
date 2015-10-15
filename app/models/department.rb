class Department < ActiveRecord::Base
  belongs_to :daycare
  has_many :department_todos, dependent: :destroy
  has_many :todos, through: :department_todos

  validates   :department_name, presence: true
end
