class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :location

  validates :product, uniqueness: {scope: :location}
end
