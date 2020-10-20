class AddManagerToDepartments < ActiveRecord::Migration[6.0]
  def change
    add_reference :departments, :manager, foreign_key: { to_table: 'users' }
  end
end
