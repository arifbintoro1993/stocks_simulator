class BaseNormalizer
  class_attribute :attribute_keys, instance_writer: false, instance_predicate: false

  self.attribute_keys = {}

  class << self
    def inherited(subclass)
      subclass.attribute_keys = attribute_keys.dup
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /^attr_for_(\w+)$/
        send(:attr_for_action, *args.unshift(Regexp.last_match[1]), &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      method_name.to_s.match(/attr_for/) || super
    end

    def action_identity(action_name)
      "#{name}_#{action_name}".underscore.to_sym
    end

    private

    def attr_for_action(action_name, *values)
      action_name = action_identity(action_name)
      attribute_keys[action_name] ||= []
      attribute_keys[action_name].push(values).flatten!
    end
  end

  protected

  def attribute_keys_for_action(action_name)
    if action_name.blank?
      attribute_keys.values.flatten.uniq
    else
      action_name = self.class.action_identity(action_name)
      attribute_keys[action_name] || []
    end
  end
end
