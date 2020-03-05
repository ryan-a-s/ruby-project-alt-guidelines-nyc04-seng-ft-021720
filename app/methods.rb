require_relative '../config/environment'

# calls the main_menu method and runs an API call to pull latest stock price data
def user_cli
    prompt = TTY::Prompt.new
    user = search_username(prompt)
    stock_price_updater
    main_menu(prompt, user)
end

# user CLI menu structure, takes both prompt and user arguments from #user_cli to maintain session
def main_menu(prompt, user)
    prompt.select("What would you like to do today?") do |menu|
        menu.choice 'Deposit Money', -> {user.make_deposit(prompt)}
        menu.choice 'View Portfolio', -> {user.check_stocks(prompt, user)}
        menu.choice 'Make a Trade', -> {user.make_trade(prompt, user)}
        menu.choice 'Make a Sale', -> {user.sell_stocks(prompt, user)}
        menu.choice 'Close Account', -> {user.close_account}
        menu.choice 'Exit', -> {exit_app}
    end    
end

# exits out of #main_menu
def exit_app
    puts `clear`
    puts "Thank you for using Lee-Trade!"
    exit
end

# prompts user to search for stock symbol and displays symbol with current price
def search_stock_symbol(prompt)
    stock_array = Stock.all.map{|stock| stock.stock_symbol + ": $#{stock.current_price}"}
    stock_name = prompt.select("Please select the stock symbol you're looking for:", stock_array, per_page: 10)
    stock_name = stock_name.split(":")[0]
    found_stock = find_stock(stock_name)
    found_stock
end

def find_stock(stock_name)
    Stock.find_by(stock_symbol: stock_name)
end

def find_username(user_name)
    User.find_by(username: user_name)
end 

# prompts user to enter their username. if valid, logs user in and shows current balance. if invalid, sends to #create_user
def search_username(prompt)
    # prompt = TTY::Prompt.new
    user_name = prompt.ask("Please enter your username:")
    if !find_username(user_name)
        user = create_user(prompt)
    else
        user = find_username(user_name)
        puts `clear`
        puts "Hello, #{user.name}, your current balance is " + "$#{user.balance.round(2)}!".colorize(:green)
    end
    return user
end

# prompt user to create a new user account with a starting balance of 50_000, populates username by downcasing full name and stripping whitespace
def create_user(prompt)
    puts `clear`
    # prompt = TTY::Prompt.new
    puts "We could not locate and account with that username, let's create a new account for you."
    full_name = prompt.ask("Please enter your full name:")
    user_name = full_name.downcase.delete(' ')
    User.create(name: full_name, username: user_name, balance: 50_000)
    puts "Welcome #{full_name}! Your username to log-in is" + " #{user_name}".colorize(:green)
    return User.find_by(username: user_name)
end

def runner
    user = search_username
end

# run an API call to pull latest data for our stock price based on stock symbol
def stock_price_updater
    stock_array = Stock.all.map{|stock| stock.stock_symbol}
    # create a visual progress bar to indicate the API data sync progress
    bar = TTY::ProgressBar.new("Updating Current Stock Prices [:bar] :percent".colorize(:yellow), total: 100)
    stock_array.each do |stock_name|
        # pulls current price of each stock
        stock_api_call(stock_name,"1min", "1","current_price",0)
        # pulls yesterdays price of each stock
        stock_api_call(stock_name,"1day", "2","yesterdays_price",1)        
        # advances the progress bar after each stocks API call
        bar.advance((100.0/Stock.all.count))
    end 
end

# API call with variables to allow return data to be customized
def stock_api_call(stock_name, interval, output_size,column_name, index)
    stock_api = RestClient.get("https://api.twelvedata.com/time_series?symbol=#{stock_name}&interval=#{interval}&outputsize=#{output_size}&format=JSON&apikey=94ceb38da2c04057b673157b6a750c5d")
    stock_price = JSON.parse(stock_api.body)
    stock_price = stock_price["values"][index]["close"].to_f.round(2)
    Stock.where('stock_symbol LIKE ?', stock_name).update_all("#{column_name}": stock_price)
end