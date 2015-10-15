class AddLanguageToDaycare < ActiveRecord::Migration
  def change
    add_column :daycares, :language, :string
  end
end
