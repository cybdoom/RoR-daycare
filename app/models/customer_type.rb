class CustomerType < ActiveRecord::Base
  has_many :daycares
  validates :name, presence: true
end
