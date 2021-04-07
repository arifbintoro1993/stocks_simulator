require 'rails_helper'

RSpec.describe Product, type: :model do
  it "product is not valid without name" do
    product = Product.new(name: nil, sku: "1234567890")
    expect(product).to_not be_valid
  end

  it "product is not valid without sku" do
    product = Product.new(name: "Product Name", sku: nil)
    expect(product).to_not be_valid
  end

  it "product is not valid with sku below 10 characters" do
    product = Product.new(name: "Product name", sku: "sku")
    expect(product).to_not be_valid
  end

  it "product is valid" do
    product = create(:product)
    expect(product).to be_valid
  end
end
