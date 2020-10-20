class CreateDepartments < ActiveRecord::Migration[6.0]
  def change
    enable_extension :citext

    create_table :departments do |t|
      t.citext :name,  null: false, index: { unique: true }
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
