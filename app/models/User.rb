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

    def make_trade
        puts "Which stock would you like to buy?"
        # use TTY to display list of stocks eventually
        stock_name_input = gets.chomp
        stock_name = Stock.find_by(stock_symbol: stock_name_input)
        puts "The current stock price for #{stock_name} is #{stock_name.current_price}"
        puts "Please enter the quantity of #{stock_name} you'd like to purchase"
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

end