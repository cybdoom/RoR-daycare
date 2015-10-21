class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
      t.belongs_to :todo, index: true, foreign_key: true
      t.datetime :schedule_date
      t.datetime :due_date
      t.string :status
      t.datetime :submitted_at


      t.timestamps null: false
    end
  end
end
