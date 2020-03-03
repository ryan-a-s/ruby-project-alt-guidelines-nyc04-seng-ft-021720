require_relative '../config/environment'

puts "Lets make some trades!"

user_cli

# search_username
# calls method from modules.rb
# search_stock_symbol

# calls method from User.rb

# ella.make_deposit
# ella.check_stocks

# ella = User.find(1)
# ryan = User.find(4)
# ryan.make_trade

# ella.close_account
# search_username

## User make_trade method deliverables
# 1. Open a menu with a list of all stocks available for purchase 
# 2. Select one stock
# 3. Returns stock price
# 4. Asks for quantity of stocks to purchase
# 5. User inputs quantity
# 6. Determines stock price * quantity 
# 7. Checks the total from 6 against user balance
# 8. If balance is sufficient, creates the Trade
# 9. Returns stock name, quantity purchased and total cost of trade
# 10. Returns the current users account balance
