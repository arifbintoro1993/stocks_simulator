class SchemaMatcher
  def initialize(options)
    @wrapper = options.delete(:wrapper)
    @options = config[:validation_options].merge(options)
  end

  def validate(object, schema)
    @schema = schema_path(schema)
    @errors = JSON::Validator.fully_validate(@schema, object_str(object), @options)
    @errors.blank?
  end

  def error_messages
    errors = @errors.map { |error| error.split(' in schema ')[0] }
    errors.reject!(&:blank?)
    errors.unshift("Expected JSON object to match schema identified by `#{schema_name}` with #{errors.count} errors")
    errors.join("\n")
  end

  private

  def schema_path(schema)
    File.join(schema_directory, "#{schema}.json")
  end

  def schema_name
    @schema.gsub(schema_directory, '')
  end

  def schema_directory
    config[:directory].to_s
  end

  def config
    RSpec.configuration.json_schema || {}
  end

  def object_str(object)
    object = transform(object)

    if object.respond_to?(:body)
      object.body
    elsif object.respond_to?(:to_json)
      to_json(object)
    else
      object.to_s
    end
  end

  def json_decode(string)
    ActiveSupport::JSON.decode(string).deep_symbolize_keys
  end

  def to_json(object)
    case object
    when Array
      wrap(object).to_json
    when Hash
      wrap_hash(object).to_json
    else
      object.to_json
    end
  end

  def wrap_hash(object)
    if object.key?(:data)
      wrap(object[:data])
    elsif object.size == 1 && object.key?(:errors) ||
          object.size <= 2 && object.key?(:message)
      object = object.dup
      object[:meta] = meta
      object
    elsif !object.key?(:meta)
      wrap(object)
    else
      object
    end
  end

  def wrap(object)
    { data: object, meta: meta }
  end

  def meta
    { http_status: HTTP_STATUS_OK }
  end

  def transform(object)
    wrap_as_collection? ? [object] : object
  end

  def wrap_as_collection?
    @wrapper == :collection
  end
end
