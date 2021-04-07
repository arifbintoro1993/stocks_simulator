class ApplicationController < ActionController::API
  include Normalizable
  include Paginatable
  include Renderable


  def resource_lookup(model_class, args = nil, default: model_class.new)
    # TODO: improve performance and fix issue with SKU mapping ID query
    model_class.find_by(args || { id: params[:id] }) || default
  end

  def valid?(resource_normalizer, http_status: 400)
    unless resource_normalizer.valid?
      render_error_serializer(build_error_from_normalizer(resource_normalizer), http_status)
    end

    !performed?
  end

  def render_response(res)
    status, body = res.values
    render status: status, json: body || ''
  end
end
