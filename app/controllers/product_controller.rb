class ProductController < ApplicationController
  def index
    products, meta = ProductService.search(Product.all, resource_params)
    render_serializer(products.to_a, current_serializer, meta: meta)
  end

  def create
    return unless valid?(current_normalizer)

    result = ProductService.create(resource_params)
    render_serializer(result, current_serializer, status: 201)
  end

  def update
    return unless valid? current_normalizer
    return not_found if current_resource.new_record?

    product = ProductService.update(current_resource, resource_params)
    render_serializer(product, current_serializer)
  end

  def destroy
    return not_found if current_resource.new_record?
    product = ProductService.destroy(current_resource)
    render_serializer(product, current_serializer)
  end

  private

  def current_normalizer
    @current_normalizer ||= ProductNormalizer.new(params)
  end

  def resource_params
    current_normalizer.permitted_attributes.to_h
  end

  def current_resource
    @resource ||= resource_lookup(Product)
  end

  def current_serializer
    ProductSerializer
  end
end