class StockNormalizer < ApplicationNormalizer
  attr_accessor :product, :location, :created_at, :total_quantity

  attr_for_index :product, :location, :created_at, :total_quantity

  def transform_attributes
    attributes
  end
end