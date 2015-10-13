class AddCustomerTypeIdToDaycare < ActiveRecord::Migration
  def change
    add_column :daycares, :customer_type_id, :integer
  end
end
