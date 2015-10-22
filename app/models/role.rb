# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_daycare_id  (daycare_id)
#
# Foreign Keys
#
#  fk_rails_fb7245d4ba  (daycare_id => daycares.id)
#

class Role < ActiveRecord::Base
  belongs_to :daycare
  has_one :user
end
