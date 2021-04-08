class CreateStockTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_transactions do |t|
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
