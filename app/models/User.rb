class User < ActiveRecord::Base

    has_many :trades
    has_many :stocks, through: :trades

# prompt user to deposit money into specified user :balance and displays balance
    def make_deposit(prompt)
        amount = prompt.ask("Please enter the amount you'd like to deposit:")
        self.balance += amount.to_f
        puts "Your account balance is $#{self.balance.round(2)}."
        self.save
    end

#Makes a trade that corresponds with the user input, if the user does not have a suitable balance it rejects the trade.
    def make_trade(prompt, user)
        stock_name = search_stock_symbol(prompt)
        # puts "The current stock price for #{stock_name.stock_symbol} is #{stock_name.current_price}"
        puts "Please enter the quantity of #{stock_name.stock_symbol} you'd like to purchase"
        stock_qty = gets.chomp.to_i
        if stock_qty <= 0
            puts "You have entered an invalid number"
            main_menu(prompt, self)
        end 
        trade_total = (stock_qty * stock_name.current_price).to_f
        if self.balance > trade_total
            self.update(balance: self.balance -= trade_total)
            Trade.create(stock_id: stock_name.id, user_id: self.id, stock_qty: stock_qty, stock_price_when_purchased: stock_name.current_price)
            puts "You purchased #{stock_qty} stocks of #{stock_name.stock_symbol} for a total of $#{trade_total}"
            puts "Your balance is now $#{self.balance.round(2)}"
        else
            puts "You do not have sufficient funds to complete this transaction, please try to purchase a smaller amount"
            main_menu(prompt, self)
        end
    end

    # checking all stocks owned by user and the associated shares for each
    def check_stocks
        # groups stocks owned by specified user and sums up the quantity per stock symbol
       # total = 0 
       array = []
        stocks_qty = self.stocks.group(:stock_symbol).sum(:stock_qty)
        stocks_qty.each do |key, value|
            stock_price = (find_stock(key).current_price * value)
            #total += stock_price
            array.push([key, value, "$#{find_stock(key).current_price}"])
           # puts "You have #{value} shares of #{key} valued at a total amount of $#{stock_price.to_f.round(2)}" # displays the amount of shares per stock symbol
        end
        #puts "You have a total portfolio value of $#{total}"
        table = TTY::Table.new header: ['Stock Symbol', 'Quantity', 'Price per share'], rows: array
        puts table.render(:unicode)
        return stocks_qty # used by close_account
    end 

    # closes account and adds all funds to users :balance
    def close_account
        stocks_qty = check_stocks
        total_amount = 0 # sets variable total_amount to 0
        # iterates through each stock owned by the user, pulls the current price from the stock table
        ## and muplies it by the quantity of stocks owned by user
        stocks_qty.each do |key, value| 
            total_amount += (find_stock(key).current_price * value)
        end
        self.update(balance: self.balance += total_amount) # adds the total amount to the users balance
        self.trades.destroy_all # removes all associated trades for that user from the trades table
        puts "Your account has been closed, your total net worth is $#{self.balance}" # displays users net worth
    end

end