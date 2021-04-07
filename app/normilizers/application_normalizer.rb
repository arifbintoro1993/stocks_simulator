class ApplicationNormalizer < BaseNormalizer
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :action_name
  attr_reader :context
  attr_reader :attributes

  def initialize(params, context = {})
    @action_name = params[:action].present? ? params[:action].to_sym : nil
    @context     = context
    @attributes  = permit_parameters(params, root: context[:root])

    perform_mapping!
  end

  def permitted_attributes
    ActionController::Parameters.new(
      ActiveSupport::HashWithIndifferentAccess.new(transform_attributes)
    ).permit!
  end

  def permitted_parameters
    attribute_keys_for_action(action_name)
  end

  def method_missing(method_name, *args, &block)
    if method_name.to_s =~ on_for_action_regex
      send(:on_for_action?, *args.unshift(Regexp.last_match[1]), &block)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s =~ on_for_action_regex || super
  end

  def add_errors(attribute, param, message = 'tidak boleh kosong')
    errors.add(attribute, message) if param.blank?
  end

  private

  def perform_mapping!
    attributes.each do |key, val|
      method_name = "#{key}="
      public_send(method_name, val) if respond_to?(method_name)
    end
  end

  def permit_parameters(hash, root: nil)
    keys = permitted_parameters

    if root.present?
      hash.require(root).permit(keys)
    else
      hash.permit(keys)
    end
  end

  def transform_attributes
    attributes.dup
  end

  def on_for_action?(action_name)
    @action_name == action_name.to_sym
  end

  def on_for_action_regex
    /^on_(\w+)\?$/
  end
end
