# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :integer
#  birth_year    :string
#  department_id :integer
#

class Child < ActiveRecord::Base
  belongs_to :parent
  belongs_to :department
  has_one :photo, as: :photoable, dependent: :destroy

  accepts_nested_attributes_for :photo, allow_destroy: true
end
