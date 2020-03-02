class CreateTradeTable < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.integer :stock_id, foreign_key: true
      t.integer :user_id, foreign_key: true
      t.integer :stock_qty
      t.integer :stock_price_when_purchased
      t.timestamps
    end 
  end
end
