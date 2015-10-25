class AddColumnDelegateeIdToUserOccurrences < ActiveRecord::Migration
  def change
    add_column :user_occurrences, :delegatee_id, :integer
    remove_column :user_occurrences, :delegated_user_id, :integer
  end
end
