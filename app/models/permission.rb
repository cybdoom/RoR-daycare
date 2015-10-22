# == Schema Information
#
# Table name: permissions
#
#  id                 :integer          not null, primary key
#  daycare_id         :integer
#  user_type          :string
#  functionality_type :string
#  type               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_permissions_on_daycare_id  (daycare_id)
#

class Permission < ActiveRecord::Base
  belongs_to :daycare
end
