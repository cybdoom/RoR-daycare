class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.belongs_to :daycare, index: true, foreign_key: true
      t.string   :user_type
      t.string   :functionality_type
      t.string   :type
      t.timestamps null: false
    end
  end
end
