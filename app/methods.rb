require_relative '../config/environment'

def user_cli
    prompt = TTY::Prompt.new
    user = search_username(prompt)
    main_menu(prompt, user)
end

def main_menu(prompt, user)
    prompt.select("What would you like to do today?") do |menu|
        menu.choice 'Search Stocks', -> {search_stock_symbol(prompt)}
        menu.choice 'Deposit Money', -> {user.make_deposit(prompt)}
        menu.choice 'View Portfolio', -> {user.check_stocks}
        menu.choice 'Make a Trade', -> {user.make_trade(prompt)}
        menu.choice 'Close Account', -> {user.close_account}
    end    
end

# prompts user to search for stock symbol and displays symbol with current price
## eventually use TTY to select stock symbol from list based on the stocks user owns
## to do - display only stock symbol and current price without SQL commands
def search_stock_symbol(prompt)
    stock_array = Stock.all.map{|stock| stock.stock_symbol}
    stock_name = prompt.select("Please select the stock symbol you're looking for:", stock_array)
    found_stock = find_stock(stock_name)
    puts "Stock #{stock_name} current price is $#{found_stock.current_price}"
    return found_stock
end

def find_stock(stock_name)
    Stock.find_by(stock_symbol: stock_name)
end

# prompts user to enter their username, makes sure username is valid
## responds with "Hello, username" and returns user as a variable
def search_username(prompt)
    # prompt = TTY::Prompt.new
    user_name = prompt.ask("Please enter your username")
    if !User.find_by(username: user_name)
        puts "We could not locate and account with that username, let's create a new account for you."
        create_user(prompt)
    else
        user = User.find_by(username: user_name)
        puts "Hello, #{user.name}!"
    end
    return user
end

# prompt user to create a new user account with a starting balance of 50_000
## auto-create username
def create_user(prompt)
    # prompt = TTY::Prompt.new
    full_name = prompt.ask("Please enter your full name:")
    user_name = full_name.downcase.delete(' ')
    User.create(name: full_name, username: user_name, balance: 50_000)
    puts "Welcome #{full_name}! Your username to log-in is #{user_name}"
    return user_name
end

def runner
    user = search_username
end

# allows user to make a trade on a stock

