class CustomerType < ActiveRecord::Base
  validates :name, presence: true
end
