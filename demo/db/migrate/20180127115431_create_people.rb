class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :handlename
      t.boolean :sex
      t.integer :syear
      t.string :bplace
      t.string :name
      t.string :email
      t.string :tel

      t.timestamps
    end
  end
end
