class StockColumnChangeCurrentPrice < ActiveRecord::Migration[5.2]
  def up
    change_column :stocks, :current_price, :float
  end

  def down 
    change_column :stocks, :current_price, :integer
  end 
end
