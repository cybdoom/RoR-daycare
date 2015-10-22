# == Schema Information
#
# Table name: departments
#
#  id              :integer          not null, primary key
#  department_name :string
#  daycare_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_departments_on_daycare_id  (daycare_id)
#

class Department < ActiveRecord::Base
  belongs_to :daycare
  has_many :department_todos, dependent: :destroy
  has_many :todos, through: :department_todos

  validates   :department_name, presence: true
end
