class AddUniqueIndexToStock < ActiveRecord::Migration[6.1]
  def change
    add_index :stocks, [:product_id, :location_id], unique: true
  end
end
