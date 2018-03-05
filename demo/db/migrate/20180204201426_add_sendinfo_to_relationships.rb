class AddSendinfoToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_column :relationships, :sendA, :boolean, default: false
    add_column :relationships, :sendB, :boolean, default: false
    add_column :relationships, :waitA, :boolean, default: false
    add_column :relationships, :waitB, :boolean, default: false
    add_index :relationships, :sendA
    add_index :relationships, :sendB
    add_index :relationships, :waitA
    add_index :relationships, :waitB
  end
end
