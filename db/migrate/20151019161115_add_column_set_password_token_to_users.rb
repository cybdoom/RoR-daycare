class AddColumnSetPasswordTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :set_password_token, :string
  end
end
