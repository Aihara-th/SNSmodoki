class AddAdminToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :admin, :boolean, default: false
  end
end
