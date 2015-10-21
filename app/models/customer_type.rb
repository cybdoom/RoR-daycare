# == Schema Information
#
# Table name: customer_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CustomerType < ActiveRecord::Base
  has_many :daycares
  validates :name, presence: true
end
