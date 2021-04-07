require 'rails_helper'

RSpec.describe Stock, type: :model do
  it 'stock is not valid without product' do
    location = create(:location)
    stock = Stock.new(product: nil, location: location)
    expect(stock).to_not be_valid
  end

  it 'stock is not valid without location' do
    product = create(:product)
    stock = Stock.new(product: product, location: nil)
    expect(stock).to_not be_valid
  end

  it 'stock is valid' do
    stock = create(:stock)
    expect(stock).to be_valid
  end

  it 'stock not valid with duplicate constraint column product and location (unique together)' do
    stock = create(:stock)

    product = stock.product
    location = stock.location

    new_stock = Stock.new(product: product, location: location)
    expect(new_stock).to_not be_valid
  end
end
