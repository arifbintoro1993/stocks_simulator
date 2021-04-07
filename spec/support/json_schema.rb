RSpec.configure do |config|
  config.add_setting :json_schema, default: {
    directory: Rails.root.join('spec', 'schemas'),
    validation_options: { validate_schema: true }
  }
end
