class AddPointToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :point, :integer, default: 0 
  end
end
