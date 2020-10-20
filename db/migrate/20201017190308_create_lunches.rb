class CreateLunches < ActiveRecord::Migration[6.0]
  def change
    create_table :lunches do |t|
      t.string :title
      t.date :lunch_date, index: { unique: true }
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
