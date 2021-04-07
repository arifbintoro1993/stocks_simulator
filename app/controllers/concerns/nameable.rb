module Nameable
  extend ActiveSupport::Concern

  def record_name(record)
    if record.is_a?(Array)
      record_name(record.first)
    elsif record.is_a?(Symbol)
      record.to_s.camelize
    elsif record.is_a?(Class)
      record.name
    else
      record.class.name
    end
  end
end
