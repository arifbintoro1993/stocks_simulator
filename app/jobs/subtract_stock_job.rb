class SubtractStockJob < ApplicationJob
  queue_as :default

  def perform(*args)
    stocks = Stock.all
    
    stock_transaction = StockTransaction.new
    stock_transaction.stock = stocks.sample
    stock_transaction.quantity = -1
    stock_transaction.save!
    sleep 2
  end 
end