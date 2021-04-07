class ProductNormalizer < ApplicationNormalizer
  attr_accessor :name, :sku, :created_at, :updated_at

  validates :name, :sku, presence: true, if: :on_create?
  
  attr_for_index :name, :sku, :created_at, :updated_at
  attr_for_create :name, :sku
  attr_for_update :name, :sku

  def transform_attributes
    attributes
  end
end
