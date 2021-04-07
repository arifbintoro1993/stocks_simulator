RSpec::Matchers.define :match_json_schema do |schema, options = { strict: false }|
  match do |object|
    @matcher = SchemaMatcher.new(options.merge(version: 'v2'))
    @matcher.validate(object, schema)
  end

  failure_message do
    @matcher.error_messages
  end
end

RSpec::Matchers.define :validate_json_schema do |schema, options = {}|
  match do |object|
    @matcher = SchemaMatcher.new(options)
    @matcher.validate(object, schema)
  end

  failure_message do
    @matcher.error_messages
  end
end
