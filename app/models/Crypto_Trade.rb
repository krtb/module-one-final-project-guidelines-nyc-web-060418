require 'pry'

class CryptoTrade < ActiveRecord::Base

  belongs_to :seller
  belongs_to :buyer

  def my_coin_value
    my_seller = self.seller
    my_seller.coin_value
  end

  def my_coin_name
    my_coin_value.coin_name
  end

  def trade_value
    my_coin_value.market_value * self.coin_quantity
  end

  def self.coin_price(name)
    coin = CoinValue.find_by(coin_name: name)
    coin.market_value
  end

  def self.all_trades_value
    counter = 0
    CryptoTrade.all.each do |trade|
      value = trade.my_coin_value.market_value * trade.coin_quantity
      counter += value
    end
    counter
  end

end
