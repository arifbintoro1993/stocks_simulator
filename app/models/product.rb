class Product < ApplicationRecord
  validates :name, presence: true
  validates :sku, presence: true, length: { minimum: 10 }

  after_create :create_stock_by_product
  before_destroy :destroy_stock_by_product

  def create_stock_by_product
    locations = Location.all

    locations.each do |location|
      Stock.find_or_create_by(
        location: location,
        product: self
      )
    end
  end

  def destroy_stock_by_product
    stock = Stock.where(product: self)
    stock.destroy_all
  end
end
