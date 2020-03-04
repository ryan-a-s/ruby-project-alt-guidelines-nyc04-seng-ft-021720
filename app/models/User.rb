class User < ActiveRecord::Base

    has_many :trades
    has_many :stocks, through: :trades

    # prompt user to deposit money into specified user :balance and displays balance
    def make_deposit(prompt)
        amount = prompt.ask("Enter the amount you'd like to deposit:")
        self.balance += amount.to_f
        puts "Your current account balance is $#{self.balance.round(2)}"
        self.save
        main_menu(prompt, self)
    end

    # makes a trade that corresponds with the user input, if the user does not have a suitable balance it rejects the trade.
    def make_trade(prompt)
        stock_name = search_stock_symbol(prompt)
        puts "Please enter the quantity of #{stock_name.stock_symbol} you'd like to purchase:"
        stock_qty = gets.chomp.to_i

        if stock_qty <= 0
            puts "You have entered an invalid number"
            main_menu(prompt, self)
        end 

        trade_total = (stock_qty * stock_name.current_price).to_f

        if self.balance > trade_total
            self.update(balance: self.balance -= trade_total)
            Trade.create(stock_id: stock_name.id, user_id: self.id, stock_qty: stock_qty, stock_price_when_purchased: stock_name.current_price)
            puts `clear`
            puts "You purchased #{stock_qty} stocks of #{stock_name.stock_symbol} for a total of" + " $#{trade_total.round(2)}".colorize(:green) + " at $#{stock_name.current_price} per share."
            puts "Your current available balance is " + "$#{self.balance.round(2)}".colorize(:green)
        else
            puts `clear`
            puts "You do not have sufficient funds to complete this transaction, please try to purchase a smaller amount.".colorize(:red)
        end
        main_menu(prompt, self)
    end

    # allow user to sell stocks based on their existing share inventory
    def sell_stocks(prompt, user)
        puts `clear`
        user.check_stocks(prompt, user)
        stock_name = search_stock_symbol(prompt)
        stock_name_string = stock_name.stock_symbol
        current_stock_qty = self.stocks.where(stock_symbol: stock_name_string).sum(:stock_qty)
        quantity = gets.chomp.to_i
        if quantity > current_stock_qty || quantity == 0 
            puts "You do not have enough shares to sell"
            main_menu(prompt, self)
        else
            total_price = (quantity * stock_name.current_price)     
            quantity = (quantity * -1 )
            Trade.create(stock_id: stock_name.id, user_id: self.id, stock_qty: quantity, stock_price_when_purchased: stock_name.current_price)
            self.update(balance: self.balance += total_price )
            puts "You have sold #{quantity * -1} shares of #{stock_name.stock_symbol} for a total of $#{total_price}"
        end
        self.trades.where(stock_id: stock_name.id).destroy_all if self.stocks.where(stock_symbol: stock_name_string).sum(:stock_qty) == 0
        main_menu(prompt, self)
    end

    # checking all stocks owned by user and the associated shares for each
    def check_stocks(prompt, user)
        # groups stocks owned by specified user and sums up the quantity per stock symbol
        puts `clear`
        array = []
        stocks_qty = self.stocks.group(:stock_symbol).sum(:stock_qty)

        stocks_qty.each do |key, value|
            current_price = find_stock(key).current_price
            yesterdays_price = find_stock(key).yesterdays_price
            differential = ((yesterdays_price - current_price).abs / yesterdays_price)*100
            if current_price > yesterdays_price
                array.push([key, value, "$#{yesterdays_price}", "$#{current_price}", "+#{differential.round(2)}".colorize(:green)])
            else
                array.push([key, value, "$#{yesterdays_price}", "$#{current_price}", "-#{differential.round(2)}".colorize(:red)])  
            end
        end

        table = TTY::Table.new header: ['Stock Symbol', 'Quantity', 'Yesterdays Share Price', 'Todays Share Price', '% Change'], rows: array
        puts table.render(:unicode)
        main_menu(prompt, self)
    end 

    # closes account and adds all funds to users :balance
    def close_account
        stocks_qty = self.stocks.group(:stock_symbol).sum(:stock_qty)
        total_amount = 0 # sets variable total_amount to 0
        # iterates through each stock owned by the user, pulls the current price from the stock table
        ## and muplies it by the quantity of stocks owned by user
        stocks_qty.each do |key, value| 
            total_amount += (find_stock(key).current_price * value)
        end
        self.update(balance: self.balance += total_amount) # adds the total amount to the users balance
        self.trades.destroy_all # removes all associated trades for that user from the trades table
        puts "Your account has been closed and funds have been transferred to your account, your current balance is $#{self.balance.round(2)}" # displays users net worth
    end

end