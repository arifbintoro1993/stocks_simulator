class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :location

  has_many :stock_transaction

  validates :product, uniqueness: {scope: :location}

  def total_quantity
    self.stock_transaction.sum(:quantity)
  end
end
