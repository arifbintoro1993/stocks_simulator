class JsonMatcher
  def initialize(object)
    @json = json_object(object)
  end

  def validate_item(keys, value)
    @keys  = keys
    @value = value
    dig(keys) == value
  end

  def validate_array_item(keys, value)
    @keys  = keys
    @value = value
    dig(keys).include?(value)
  end

  def error_messages
    "expected '#{dig(@keys)}' to match message '#{@value}'"
  end

  def negated_error_messages
    "expected '#{dig(@keys)}' to not match message '#{@value}'"
  end

  private

  def dig(keys)
    @json.dig(*keys)
  end

  def json_object(object)
    if object.respond_to?(:body)
      json_decode(object.body)
    elsif object.respond_to?(:symbolize_keys)
      object.symbolize_keys
    else
      object
    end
  end

  def json_decode(string)
    ActiveSupport::JSON.decode(string).deep_symbolize_keys
  end
end
