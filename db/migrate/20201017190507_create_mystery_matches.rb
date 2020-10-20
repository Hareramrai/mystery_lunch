class CreateMysteryMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :mystery_matches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lunch_team, null: false, foreign_key: true
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
