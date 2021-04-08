class StockSerializer < ApplicationSerializer
  attribute :id
  attribute :product
  attribute :location
  attribute :created_at
  attribute :total_quantity
end