class Role < ActiveRecord::Base
  belongs_to :daycare
  has_one :user
end
