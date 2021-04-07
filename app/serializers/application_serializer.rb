class ApplicationSerializer < ActiveModel::Serializer
  attribute :registered_cache_keys, key: :_cache_keys, if: :embed_cache_keys?

  def http_status
    instance_options.fetch(:status, HTTP_STATUS_OK)
  end

  def custom_serialization(object, serializer_class)
    options = instance_options.merge(serializer: serializer_class)
    ActiveModelSerializers::SerializableResource.new(object, options).serializable_hash
  end

  def cache_key(_adapter)
    expand_cache_key(cache_identity)
  end

  def registered_cache_keys
    self.class.cache_enabled? ? construct_cache_relationship_keys : {}
  end

  def embed_cache_keys?
    instance_options.fetch(:embed_cache_keys, false)
  end

  def as_utc(value)
    case value
    when Time
      value.utc
    when DateTime
      value.to_time.utc
    else
      value
    end
  end

  def fetch(key, options = nil)
    name, data = fragment_info(key)

    return if name.blank?

    Rails.cache.fetch(name, options) { block_given? ? yield(data) : data }
  end

  def t(key, options = {})
    I18n.t("serializers.#{serializer_key}.#{key}", options)
  end

  def purge
    return unless self.class.cache_enabled?

    cache_key(nil).tap do |name|
      self.class.cache_store.delete(name)
    end
  end

  private

  def construct_cache_relationship_keys
    association_cache_keys.tap do |hash|
      hash[:_self] = cache_key(nil)
      hash.compact!
    end
  end

  def association_cache_keys
    associations.each_with_object({}) do |association, hash|
      hash.merge!(build_association_info(association))
      hash
    end
  end

  def build_association_info(association)
    { association_name(association) => association_serializer_cache_key(association.serializer) }
  end

  def association_name(association)
    association.options.fetch(:key, association.name).to_sym
  end

  def association_serializer_cache_key(serializer)
    if serializer.respond_to?(:map)
      serializer.map { |r| r.cache_key(nil) }
    else
      serializer.cache_key(nil)
    end
  end

  def cache_identity
    raise NotImplementedError, 'You must implement `cache_identity`.'
  end

  def expand_cache_key(parts)
    ActiveSupport::Cache.expand_cache_key(Array.wrap(parts), 'v4')
  end

  def fragment_cache_key(parts)
    expand_cache_key(%w[fragments].concat(fragment_suffix(parts)))
  end

  def fragment_suffix(parts)
    Array.wrap(parts)
  end

  def fragment_info(key)
    return fragment_cache_key(key) if key.is_a?(Array)
    return unless object.respond_to?(key)

    key  = "fetch_#{key}" if object.respond_to?("fetch_#{key}")
    data = object.public_send(key)
    name = data.respond_to?(:cache_key) ? fragment_cache_key([data, self.class.name.underscore]) : fragment_cache_key([object, key, self.class.name.underscore])

    [name, data]
  end

  def serializer_key
    self.class.name.remove('PublicSerializer', 'Serializer').underscore
  end
end
