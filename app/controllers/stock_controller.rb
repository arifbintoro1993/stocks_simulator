class StockController < ApplicationController
  def index
    stocks, meta = StockService.search(Stock.all, resource_params)
    render_serializer(stocks.to_a, current_serializer, meta: meta)
  end

  def show
    return not_found if current_resource.new_record?
    render_serializer(current_resource, current_serializer)
  end

  private

  def current_normalizer
    @current_normalizer ||= StockNormalizer.new(params)
  end

  def resource_params
    current_normalizer.permitted_attributes.to_h
  end

  def current_resource
    @resource ||= resource_lookup(Stock)
  end

  def current_serializer
    StockSerializer
  end
end