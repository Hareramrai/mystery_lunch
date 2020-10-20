class CreateLunchTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :lunch_teams do |t|
      t.references :lunch, null: false, foreign_key: true
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
