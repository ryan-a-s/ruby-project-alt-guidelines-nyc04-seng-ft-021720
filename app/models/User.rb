class User < ActiveRecord::Base

    has_many :trades
    has_many :stocks, through: :trades

# prompt user to deposit money into specified user :balance and displays balance
    def make_deposit
        puts "Please enter the amount you'd like to deposit"
        amount = gets.chomp.to_i
        self.balance += amount
        self.save
    end

#Makes a trade that corresponds with the user input, if the user does not have a suitable balance it rejects the trade.
    def make_trade
        puts "Which stock would you like to buy?"
        # use TTY to display list of stocks eventually
        stock_name_input = gets.chomp
        stock_name = Stock.find_by(stock_symbol: stock_name_input)
        puts "The current stock price for #{stock_name.stock_symbol} is #{stock_name.current_price}"
        puts "Please enter the quantity of #{stock_name.stock_symbol} you'd like to purchase"
        stock_qty = gets.chomp.to_i
        trade_total = (stock_qty * stock_name.current_price)
        if self.balance > trade_total
            self.update(balance: self.balance -= trade_total)
            Trade.create(stock_id: stock_name.id, user_id: self.id, stock_qty: stock_qty, stock_price_when_purchased: stock_name.current_price)
            puts "You purchased #{stock_qty} stocks of #{stock_name.stock_symbol} for a total of #{trade_total}"
            puts "Your balance is now #{self.balance}"
        else
            puts "You do not have sufficient funds to complete this transaction."
        end
    end

    # checking all stocks owned by user and the associated shares for each
    def check_stocks
        # groups stocks owned by specified user and sums up the quantity per stock symbol
        stocks_qty = self.stocks.group(:stock_symbol).sum(:stock_qty)
        stocks_qty.each do |key, value|
            puts "You have #{value} shares of #{key}" # displays the amount of shares per stock symbol
        end
        stocks_qty
    end 

    # closes account and adds all funds to users :balance
    def close_account
        stocks_qty = check_stocks
        total_amount = 0 # sets variable total_amount to 0
        # iterates through each stock owned by the user, pulls the current price from the stock table
        ## and muplies it by the quantity of stocks owned by user
        stocks_qty.each do |key, value| 
            total_amount += (Stock.find_by(stock_symbol: key).current_price * value)
        end
        self.update(balance: self.balance += total_amount) # adds the total amount to the users balance
        self.trades.destroy_all # removes all associated trades for that user from the trades table
        puts "Your account has been closed, your total net worth is $#{self.balance}" # displays users net worth
    end

end