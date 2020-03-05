
LEE-TRADE: The Stock Trading App of the Future!
===============================================

## Lee-Trade is a next-gen CLI-based stock trading app
### With Lee-Trade, you can do the following:

- Log into your account with a username, or create a new account
- Purchase stocks
- Sell stocks
- Deposit money into your account
- View your current portfolio, complete with % change since yesterday
- Close your Lee-Trade account
- Maintain your user session throughout the

## INSTALLATION INSTRUCTIONS

1. Go to https://github.com/ryan-a-s/ruby-project-alt-guidelines-nyc04-seng-ft-021720
2. Clone the repo to your local computer
3. Within the app directory, run 'bundle' to install required Gems
4. Open the repo and run 'ruby bin/run.rb' to start the application

## HOW TO USE LEE-TRADE

1. Upon running the CLI app, you will be prompted for a username. 
2. Enter a username, and if you are not yet in the system, it will prompt you to set up an account.
3. Once your account has been found (or created), the application will run an API call to TwelveData to load both current stock prices and the prices from the close of the previous day. While the API data is being pulled, a progress bar called "Updating Current Stock Prices" will show the real-time status of the data sync.
4. You will now be able to choose from the following options:


    - **Deposit Money:** Deposit money into your account.

    - **View Portfolio:** View a formatted table of all stocks you've own shares of, the quantity of shares owned and the current share price.

    - **Make a Trade:** View a list of stocks you can purchase, and enter the quantity of shares you'd like to purchase. If you have the available funds, you will be able to purchase the quantity of shares specified. Otherwise, you will be sent back to the main menu.

    - **Make a Sale:** View your current portfolio of stocks you can sell and their current share price. Select the stock you'd like to sell, and enter the quantity of shares you'd like to sell. The quantity entered will be checked against available stocks, once confirmed you will be able to sell the quantity of shares specified. Otherwise, you will receive an error and be sent back to the main menu.

    - **Close Account:** Close your Lee-Trade account (sad-face) which will trigger a sale of all shares owned at their current stock price and add those funds back to your account.

    - **Exit:** Log out of Lee-Trade.

#### Created by Stanley Lee and Ryan Seit