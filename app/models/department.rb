class Department < ActiveRecord::Base
  belongs_to :daycare

  validates   :department_name, presence: true
end
