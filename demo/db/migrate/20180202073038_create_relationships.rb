class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :personA_id
      t.integer :personB_id
      t.integer :value

      t.timestamps
    end
    add_index :relationships, :personA_id
    add_index :relationships, :personB_id
    add_index :relationships, :value
    add_index :relationships, [:personA_id, :personB_id], unique: true
  end
end
