class UserColumnChangeBalanceToFloat < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :balance, :float
  end
  
  def down 
    change_column :users, :balance, :integer
  end 
end