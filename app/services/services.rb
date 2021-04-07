# Service Object implements the user interactions with the application.
# When to use
#   - Business logic is duplicated among controllers or jobs
#   - Business logic is reaching across multiple models
#   - Model or controller gets too fat or too complex
#   - Action is additional to the model, such as notifying
#   - Calling external service
#
# Basic Principles
#   - Serves one specific purpose (Single Responsibility Principle)
#   - A service can act as a wrapper, e.g. calling multiple services. Example: PurchaseService::Create
#
# Conventions
# Strict:
#   - Namespace with domain name
#   - use the facade module to call
#   - Use verb as class name
#   - Have only one public method
#     Remember that it should only serves one specific purpose. If one public method is not sufficient, maybe your service is doing too much?
#   - extend the Service::Base class

module Services
  class Base
    extend ActiveModel::Callbacks
    include Contracts::Core
    include LogActivity

    C = Contracts

    define_model_callbacks :perform
    around_perform :log_activity

    class << self
      def after_success_perform(method = nil, &block)
        after_success_perform_callbacks << [method, block]
      end

      def after_success_perform_callbacks
        @after_success_perform_callbacks ||= []
      end
    end

    def call
      run_callbacks :perform do
        perform
      end
    end

    def perform
      raise NotImplementedError
    end

    def log(warehouse, system, status, obj, msg)
      MessageBoardService.create(warehouse, system, status, obj, msg)
    end

  end

  class DataCSVError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super(@data)
    end
  end

  # Base exception occurred on service layer
  class ServiceError < LancelotError
    def initialize(msg = nil)
      msg ||= error_message
      super(msg)
    end

    def path
      "services.errors.#{self.class.name.deconstantize.underscore}.#{self.class.name.demodulize.underscore}"
    end

    def error_message(*opts)
      I18n.t(path, *opts)
    end
  end

  # For other errors not logically occurred from service layer
  # Exception which occurred on Core layer also will be wrapped into this
  # that cannot be handled anymore
  # e.g : ActiveRecord::RecordInvalid
  class SystemError < ServiceError; end

  # some paramater is required to run the service is not provided
  class BadParameterError < ServiceError; end

  class EmptyFileError < ServiceError; end

  class InvalidCsvFormatError < ServiceError; end

  class InvalidDateFormatError < ServiceError; end

  # some parameters that were required to run the service is not provided
  class MissingParameterError < ServiceError
    def initialize(field = nil)
      super error_message(field: field)
    end
  end

  class NotFoundMappingId < ServiceError
    def initialize(mapping_id)
      super error_message(mapping_id: mapping_id)
    end
  end

  class NotNewRecord < ServiceError
    def initialize(object)
      super error_message(obj_name: object.class.name)
    end
  end

  class RecordNotFound < ServiceError
    def initialize(obj_name = nil, id = nil)
      super error_message(obj_name: obj_name, id: id)
    end
  end

  class UnexpectedParameterTypeError < ServiceError
    def initialize(field, actual, expected)
      super error_message(field: field, actual: actual, expected: expected)
    end
  end
end
