class AddDisclosureToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_column :relationships, :disclosure, :integer, default: 0
    add_index :relationships, :disclosure
  end
end
