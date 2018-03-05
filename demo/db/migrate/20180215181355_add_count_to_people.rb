class AddCountToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :count, :integer, default: 0 
  end
end
