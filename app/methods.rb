require_relative '../config/environment'

def stanley_method
   puts User.all
end

def search_stock_symbol
    puts "Please enter the stock symbol you're looking for"
    stock = gets.chomp.upcase
    found_stock = Stock.find_by(stock_symbol: stock)
    puts "Stock #{stock} current price is #{found_stock.current_price}"
end