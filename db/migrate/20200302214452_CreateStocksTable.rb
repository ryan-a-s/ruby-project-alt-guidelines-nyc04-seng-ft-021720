class CreateStockTable < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :stock_symbol
      t.integer :current_price
      t.string :category
  end
end
