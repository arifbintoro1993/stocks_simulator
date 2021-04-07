module Renderable
  extend ActiveSupport::Concern

  def render_serializer(resource_or_resources, serializer, options = {})
    options = get_serializer_options(resource_or_resources, serializer, options || {})
    render(options.merge(json: resource_or_resources))
  end

  def render_error_serializer(resource_or_resources, status, options = {})
    render_serializer resource_or_resources, error_serializer, options.merge(status: status)
  end

  def get_serializer(resource, options = {})
    super(resource, options.merge(adapter: AdapterSerializer))
  end

  def get_serializer_options(resource_or_resources, serializer, options)
    options.symbolize_keys!
    options.except!(:serializer, :each_serializer)

    serializer_key = serializer_option_key(resource_or_resources)
    options[serializer_key] = serializer

    options[:meta] ||= {}
    options[:meta].merge!(serializer_meta_collector)
    options[:embed_cache_keys] ||= true
    options
  end

  def error_serializer; ErrorSerializer; end

  def notice_serializer; NoticeSerializer; end

  def build_notice(message, options = {})
    Api::Notice.new(message, options)
  end

  private

  def serializer_option_key(resource_or_resources)
    return :serializer if plain_serializer_object?(resource_or_resources)
    resource_or_resources.is_a?(Array) ? :each_serializer : :serializer
  end

  def plain_serializer_object?(resource_or_resources)
    resource_or_resources.public_methods(false) == [:data]
  end

  def serializer_meta_collector
    registered_keys = request.env.keys.select { |key| key =~ /meta\.\w+/ }
    registered_keys.each_with_object({}) { |key, hash| hash[key.gsub('meta.', '')] = request.env[key] }
  end
end
