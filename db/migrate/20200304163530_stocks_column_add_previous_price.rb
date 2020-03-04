class StocksColumnAddPreviousPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :yesterdays_price, :float
  end
end
