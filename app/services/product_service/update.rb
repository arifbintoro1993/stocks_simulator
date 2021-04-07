module ProductService
  class Update < ApplicationService
    attr_reader :product, :params

    def initialize(product, params)
      @product = product
      @params = params
    end

    def perform
      product.name = params[:name]
      product.sku = params[:sku]
      product.save!

      product
    rescue StandardError => e
      raise e
    end
  end
end