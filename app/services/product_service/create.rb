module ProductService
  class Create < ApplicationService
    def initialize(params)
      @name = params[:name]
      @sku = params[:sku]
    end

    def perform
      product = Product.create!(
          name: @name,
          sku: @sku
      )
      product.save!
      product
    end
  end
end