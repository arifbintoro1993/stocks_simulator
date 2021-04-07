class AdapterSerializer < ActiveModelSerializers::Adapter::Base
  def serializable_hash(options = nil)
    options = serialization_options(options)
    hash = serialized_hash(options)
    hash[meta_key] = meta
    trim!(hash, options)
  end

  private

  def serialized_hash(options)
    json = serializer.serializable_hash(instance_options, options, self)

    if json.is_a?(Array)
      serialized_hash_for_collection(json)
    else
      serialized_hash_for_single_resource(HashWithIndifferentAccess.new(json))
    end
  end

  def serialized_hash_for_single_resource(json)
    errors = json.extract!(:errors)

    return errors if errors.present?

    message = json.extract!(:message)
    data    = wrap(json)

    return data if message.blank?

    data[root].empty? ? message : message.merge(data)
  end

  def serialized_hash_for_collection(json)
    { root => json }
  end

  def serialization_options(options)
    options ||= {}
    options[:key_transform]   = :unaltered
    options[:fields]        ||= instance_options[:fields]
    options
  end

  def meta
    metadata = instance_options.fetch(:meta, {})
    metadata[:http_status] = http_status
    metadata[:limit]  = metadata.delete(:limit).to_i  if metadata.key?(:limit)
    metadata[:offset] = metadata.delete(:offset).to_i if metadata.key?(:offset)
    metadata
  end

  def meta_key
    instance_options.fetch(:meta_key, 'meta'.freeze)
  end

  def http_status
    status   = serializer.try(:http_status)
    status ||= serializer.first.try(:http_status) if serializer.respond_to?(:first)
    status ||= HTTP_STATUS_OK
    status
  end

  def root
    root_key.to_s
  end

  def root_key
    instance_options.fetch(:root_key, 'data'.freeze)
  end

  def wrap(json)
    json.key?(:data) ? { root => json.delete(:data) } : { root => json }
  end

  def trim!(data, options = {})
    data.deep_stringify_keys!
    deep_reject_keys_in_object(data) { |key| key.start_with?('_') unless options[:embed_private_keys] }
  end

  def deep_reject_keys_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, val), result|
        result[key] = deep_reject_keys_in_object(val, &block) unless yield(key)
      end
    when Array
      object.map { |e| deep_reject_keys_in_object(e, &block) }
    else
      object
    end
  end
end
