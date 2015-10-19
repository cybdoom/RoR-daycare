class UserDevice < ActiveRecord::Base
  belongs_to :user
  belongs_to :device

  STATUS = %w(active inactive)
  # attr_accessible :device_id, :status, :user_id

  UserDevice::STATUS.each do |status|
    # define methods such as active?, inactive? etc.
    define_method "#{status}?" do
      self.status == status
    end
  end

  def activate_user_device
  	device.user_devices.where(status: :active).update_all(status: :inactive)
  	change_status_to(:active)
  end

  def deactivate_user_device
  	change_status_to(:inactive)
  end


  private
  def change_status_to(status)
  	self.status = status
  	self.save!
  end
end
