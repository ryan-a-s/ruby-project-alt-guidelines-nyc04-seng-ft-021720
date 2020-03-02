# User 
# puts "Creating Users"
# 2.times do 
#     User.create(name: Faker::FunnyName.name, balance: 50_000)
# end 
# puts "Users created"



#Stocks

puts "Creating Stocks"

Stock.create(stock_symbol: 'GOOGL', current_price: 1386.32, category: "Tech")
Stock.create(stock_symbol: 'NFLX', current_price: 381.05, category: "Entertainment")
Stock.create(stock_symbol: 'FB', current_price: 196.44, category: "Social Media")
Stock.create(stock_symbol: 'AMZN', current_price: 1953.95, category: "Shopping")
Stock.create(stock_symbol: 'TSLA', current_price: 743.62, category: "Automotive")


puts "Stocks created"

