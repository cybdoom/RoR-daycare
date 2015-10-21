# == Schema Information
#
# Table name: children
#
#  id         :integer          not null, primary key
#  name       :string
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_children_on_daycare_id  (daycare_id)
#

class Child < ActiveRecord::Base
  belongs_to :daycare
end
