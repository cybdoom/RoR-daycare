class Daycare < ActiveRecord::Base
  has_one  :manager, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :parents, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :todos, dependent: :destroy

  accepts_nested_attributes_for :manager, :departments, allow_destroy: true, reject_if: :all_blank

end
