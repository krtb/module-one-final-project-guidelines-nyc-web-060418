require_relative '../app/models/coin_value.rb'
require_relative '../app/models/asset.rb'
require_relative '../app/models/buyer.rb'
require_relative '../app/models/seller.rb'
require_relative '../app/models/crypto_trade.rb'

def welcome_message
  puts " ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗          ██████╗██████╗  █████╗ ███████╗██╗  ██╗
██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗        ██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║
██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║        ██║     ██████╔╝███████║███████╗███████║
██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║        ██║     ██╔══██╗██╔══██║╚════██║██╔══██║
╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝███████╗╚██████╗██║  ██║██║  ██║███████║██║  ██║
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                                                   "
end

def main_menu
  prompt = TTY::Prompt.new
  answer = prompt.select('Choose an option from the main menu:', %w(Play High_Score Credits))

  if answer == "Credits"
    puts "Created by Kurt Bauer and Noah Berman for
    the Flatiron School's Module 1 Final Project. 
    © 2018, all rights reserved."
    sleep(1)
    main_menu
  elsif answer == "High_Score"
    puts "High_Score..."
    sleep(1)
    main_menu
  else
    puts "Let's play!"
    sleep(1)
  end
end

def name_getter
  puts "What's your name?"
  user_name = gets.chomp
  Buyer.create(name: user_name, cash: 1000, playing?: true, score: 0)
  "Hi, #{user_name}, let's get started!"
end

def current_player
  player = Buyer.find_by(playing?: true)
  player
end

def introduction
  puts "**********************************************************************************"
  puts "The year is 2018. A dark cloud is spreading over Western Civilizatiion..."
  sleep(2)
  puts "In a last-ditch effort to prop up the dollar, the US Government is planning
  on criminalizing the purchase, sale, and posession of all cryptocurrencies."
  sleep(5)
  puts "You, a nascent crypto-trader, find this development untenable. You plan a
  quick escape to the crypto-haven of Canada, but need to raise $5,000 in 3 days for a ticket
  on the last flight."
  sleep(5)
  puts "You have only $1,000 in cash and your last 3 posessions for barter."
  sleep(3)
  puts "Can you raise $5,000 in cryptocurrencies and escape crypto-tyrrany?"
  puts "**********************************************************************************"
  sleep(2)
end

def asset_getter
  puts "Please enter 3 things that are most valuable to you:"
  asset_one = gets.chomp
  asset_two = gets.chomp
  asset_three = gets.chomp
  current_player.declare_assets(asset_one, asset_two, asset_three)
end

def turn_method(day_integer)
  prompt = TTY::Prompt.new
  turn = prompt.select('Please select from the following options:', %w(
    Buy_Crypto_Coin
    View_Assets
    Sell_Assets
    View_My_Coins
    View_My_Cash
    End_Turn
    ))


    if turn == "View_Assets"
      current_player.view_assets
      turn_method(day_integer)
    elsif turn == "Sell_Assets"
      prompt = TTY::Prompt.new
      asset = prompt.ask("Which asset would you like to Sell?")
      puts "Oof, okay, you sold your #{asset}"
      current_player.sell_assets(asset)
      turn_method(day_integer)
    elsif turn == "View_My_Coins"
      player_wallet = current_player.my_wallet
        if player_wallet == {}
          puts "Your wallet is empty"
          turn_method(day_integer)
        else
          broken_strings = player_wallet.split
          find_price = broken_strings.select do |word|
            word == "price"
          end
          if find_price.join != "price"
              sleep(1)
              puts "You have no coins!"
              sleep(1)
              turn_method
          else
            puts player_wallet
            turn_method(day_integer)
          end
        end
    elsif turn == "View_My_Cash"
      puts "You have $#{current_player.cash} in cash."
      turn_method(day_integer)
    elsif turn == "Buy_Crypto_Coin"
      current_player.view_coin_market
      prompt = TTY::Prompt.new
      answer = prompt.ask("Enter the number of the seller you wish to buy from. [Enter 'quit' to return to menu]")
        if answer == "quit"
          turn_method(day_integer)
        elsif
          if Seller.find(answer)
            quant_answer = prompt.ask("Enter the quantity of coins you wish to purchase. [Enter 'quit' to return to menu]")
            current_player.trade(answer, quant_answer)
            turn_method(day_integer)
          else
            puts "Not a valid response. Please try again."
            turn_method(day_integer)
          end
        end
    else turn == "End_Turn"
      puts "You ended day #{day_integer} with $#{current_player.cash} in cash and $#{CryptoTrade.all_trades_value} worth of cryptocurrency."
    end
end

def calculate_score
  puts "Now calculating your final score..."
  sleep(1)
  coin_score = []
  current_player.my_trades.each do |trade|
    coin_score << current_player.find_coin_market_value(trade)
  end
  total = coin_score.inject{|sum, e| sum + e}
  total
end

def event
  # Randomly picks an event to occur that affects
  event_id = rand(1..10)
    # Event 1
    puts "Kim Jung Un pegged North Korea's currency to Litecoin! All crypto prices are increased by 400%"


def end_game
  if calculate_score > 5000
    sleep(1)
    puts "Game over! You win!"
    sleep(1)
  else
    sleep(1)
    puts "LOSERRRRR"
    sleep(1)
  end
end
