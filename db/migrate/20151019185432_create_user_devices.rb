class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.integer :user_id, null: false
      t.integer :device_id, null: false
      t.string :status
      t.timestamps null: false
    end
  end
end
