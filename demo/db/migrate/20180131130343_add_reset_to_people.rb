class AddResetToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :reset_digest, :string
  end
end
