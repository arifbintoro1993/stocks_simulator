module Normalizable
  include Nameable
  extend ActiveSupport::Concern

  def permitted_attributes(record, root: nil)
    normalizer(record, root: root).permitted_attributes
  end

  def permitted_parameters(record)
    normalizer(record).permitted_parameters
  end

  def normalizer(record, context = {})
    klass = normalizer_class_name(record).safe_constantize
    klass.new(context.fetch(:params, params), context.merge(current_user: current_user))
  end

  def build_error_from_normalizer(normalizer)
    build_error_from_record_errors(normalizer.errors.messages)
  end

  private

  def normalizer_class_name(record)
    "#{normalizer_record_name(record)}#{normalizer_suffix}"
  end

  def normalizer_suffix
    'Normalizer'
  end

  def normalizer_record_name(record)
    record_name(record)
  end
end
