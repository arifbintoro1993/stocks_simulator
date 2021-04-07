status_ok_format    = ->(value) { raise JSON::Schema::CustomFormatError, "must be OK not #{value}" unless value == 'OK' }
status_error_format = ->(value) { raise JSON::Schema::CustomFormatError, "must be ERROR not #{value}" unless value == 'ERROR' }

MAIL_REGEXP = /\A\s*([^@\s]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i

email_format = lambda do |value|
  unless MAIL_REGEXP.match?(value)
    raise JSON::Schema::CustomFormatError, "must be valid email address (#{value})"
  end
end

store_level_name_format = lambda do |value|
  level_names = StorePublicSerializer::STORE_LEVELS.map { |name| I18n.t("serializers.store.store_level.#{name}") }

  unless level_names.include?(value)
    raise JSON::Schema::CustomFormatError, "must be valid store level name (#{value})"
  end
end

empty_string_format = ->(value) { raise JSON::Schema::CustomFormatError, "must be EMPTY STRING (#{value})" unless value == '' }

supported_couriers_format = lambda do |value|
  unless (value - Payment::ShippingFee::Services.values).blank?

  end
end

phone_number_format = lambda do |value|
  unless Phonelib.valid_for_country?(value, 'ID')
    raise JSON::Schema::CustomFormatError, "must be valid phone number in Indonesia (#{value})"
  end
end

class DateTimeFormat < JSON::Schema::FormatAttribute
  class << self
    def validate(current_schema, data, fragments, processor, validator, options = {})
      unless api_v4?(current_schema.uri)
        default_validate(current_schema, data, fragments, processor, validator, options)
        return
      end

      error_message = "must be valid UTC date time (#{data})"
      value = to_datetime(data)

      if value.nil?
        default_validate(current_schema, data, fragments, processor, validator, options)
        return
      end

      unless value.utc?
        validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors])
      end
    end

    def api_v4?(uri)
      uri.to_s.include?('v4')
    end

    def to_datetime(data)
      data.to_datetime
    rescue ArgumentError
      nil
    end

    def default_validate(current_schema, data, fragments, processor, validator, options = {})
      JSON::Schema::DateTimeFormat.validate(current_schema, data, fragments, processor, validator, options)
    end
  end
end

# api-v2
JSON::Validator.register_format_validator('status_ok', status_ok_format)
JSON::Validator.register_format_validator('status_error', status_error_format)

# api-v4
JSON::Validator.register_format_validator('email', email_format)
JSON::Validator.register_format_validator('empty-string', empty_string_format)
JSON::Validator.register_format_validator('store-level-name', store_level_name_format)
JSON::Validator.register_format_validator('supported-couriers', supported_couriers_format)
JSON::Validator.register_format_validator('phone-number', phone_number_format)

# always use draft4
validators = JSON::Validator.validator_for_name('draft4')
validators.formats['date-time'] = DateTimeFormat
JSON::Validator.register_default_validator(validators)
