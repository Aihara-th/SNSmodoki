class AddIndexToPeopleEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :People, :email, unique: true
  end
end
