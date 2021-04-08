module StockService
  module_function

  def search(*args); StockService::Search.new(*args).call; end
end