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

class EditPermission < Permission
end
