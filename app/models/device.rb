# == Schema Information
#
# Table name: devices
#
#  id           :integer          not null, primary key
#  device_token :string
#  device_type  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Device < ActiveRecord::Base

  VALID_DEVICES = %w(android ios)
  has_many :user_devices
  has_many :users, through: :user_devices

  # has_one :active_user_device, conditions: {status: :active}, class_name: 'UserDevice'
  # has_one :active_user, through: :active_user_device, source: :user
  validates :device_token, :device_type, presence: true
  validates :device_token, uniqueness: { scope: [:device_type]}
  validate :valid_device_type
  scope :with_type, lambda { |type| where("device_type = ?", type)}
  scope :with_token, lambda { |token| where("device_token = ?",token)}

  def self.with_token_and_type(device_token, device_type)
    with_type(device_type).with_token(device_token).first
  end

  private
    def valid_device_type
      errors.add(:device_type, "is invalid") unless Device::VALID_DEVICES.include?(device_type)
    end 
end
