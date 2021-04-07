class Location < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { minimum: 10 }

  after_create :create_stock_by_location
  before_destroy :destroy_stock_by_location

  def create_stock_by_location
    products = Product.all
    products.each do |product|
        Stock.find_or_create_by(
          product: product,
          location: self
        )
    end
  end

  def destroy_stock_by_location
    stock = Stock.where(location: self)
    stock.destroy_all
  end

end
