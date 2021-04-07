module ProductService
  class Destroy < ApplicationService
    attr_reader :product

    def initialize(product)
      @product = product
    end

    def perform
      product.destroy!
    rescue StandardError => e
      raise e
    end
  end
end