class LocationNormalizer < ApplicationNormalizer
  attr_accessor :name, :code, :created_at, :updated_at

  validates :name, :code, presence: true, if: :on_create?

  attr_for_index :name, :code, :created_at, :updated_at
  attr_for_create :name, :code
  attr_for_update :name, :code

  def transform_attributes
    attributes
  end
end