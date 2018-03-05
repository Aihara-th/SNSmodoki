class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :person, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:person_id, :created_at]
  end
end
