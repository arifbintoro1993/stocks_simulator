module Queryable
  extend ActiveSupport::Concern
  include Paginatable
  include Sortable

  QUERY_RANGE_ENDING = %w[_lt _gt].freeze

  def call_query(model_query, params)
    remove_existing_query_params(model_query, params)
    range_query = build_range_query(model_query, params)
    sort_attributes = sort(klass_attributes(model_query))

    scoped = build_query(model_query, params, range_query).order(sort_attributes)

    meta = build_meta(scoped)
    data = build_data(scoped)

    [data, meta]
  end

  private

  #
  # Remove param if it's already included in model query (ActiveRecord Relation)
  #
  # Example:
  #   model_query = DeliveryOrder.where(warehouse_id: 1)
  #   params = { warehouse_id: 2 }
  #
  #   build_query will create invalid query of DeliveryOrder.where(warehouse_id: 1).where(warehouse_id: 2)
  #   if existing param in model_query is not removed from params
  #
  def remove_existing_query_params(model_query, params)
    existing_query = model_query.where_values_hash
    params.delete_if { |key| existing_query.key? key }
  end

  #
  # Convert range parameters into range queries and remove them from params
  #
  # Example:
  #   params = { warehouse_id: 1, created_at_gt: '2018-01-01 09:00:00', updated_at_lt: '2019-01-01 09:00:00' }
  #
  #   build_range_query will remove range parameters from params and create range query, so that
  #   params == { warehouse_id: 1 }
  #   range_query == { sql: ['created_at >= ?', 'updated_at <= ?'], parameters: ['2018-01-01 09:00:00', '2019-01-01 09:00:00'] }
  #
  # Query value will also be parsed with time zone if column type is datetime
  #
  def build_range_query(model_query, params)
    raw_range_params = params.select { |key| key.to_s.end_with?(*QUERY_RANGE_ENDING) }
    params.delete_if { |key| raw_range_params.key? key }

    valid_attributes = klass_attributes(model_query)
    range_query = { sql: [], parameters: [] }

    raw_range_params.each do |key, value|
      base_key = key.slice(0..-4)
      direction = key.slice(-3..-1) == QUERY_RANGE_ENDING.first ? '<=' : '>='

      next unless valid_attributes.include? base_key
      value = Time.zone.parse(value) if model_query.columns_hash[base_key].type == :datetime

      range_query[:sql] << "#{base_key} #{direction} ?"
      range_query[:parameters] << value
    end

    range_query
  end

  #
  # build active record query using params and range_query
  #
  # Resulting query will be something like:
  #   model_query.where(x: 123, y: 456).where('a >= ? AND b <= ?', 10, 20)
  #
  def build_query(model_query, params, range_query)
    model_query
      .where(permitted_params(model_query, params))
      .where(range_query[:sql].join(' AND '), *range_query[:parameters])
  end

  #
  # Get all column names and associations belongs to model query
  #
  # Example:
  #   Warehouse has column id, name, partner_id (belongs to Partner)
  #
  # This method will return [:id, :name, :partner_id, :partner]
  #
  # It also returns association name since we can query using relation
  #
  def klass_attributes(model_query)
    @klass_attributes ||=
      begin
        klass = model_query.klass

        column_names = klass.column_names.dup
        associations = klass.reflect_on_all_associations.map(&:name).map(&:to_s)

        column_names.push(*associations)
      end
  end

  #
  # Get permitted params by intersecting klass_attributes and params' keys
  #
  # Example:
  #   klass_attributes = [:id, :name, :partner_id, :partner]
  #   params = { name: 'name', user_id: 1 }
  #   permitted_params = { name: 'name' }
  #
  # If params is not filtered, when we query using command
  #
  #                 model_query.where(params)
  #
  # then it will cause error column user_id not found
  #
  def permitted_params(model_query, params)
    keys = params.keys.map(&:to_s)
    permitted_keys = klass_attributes(model_query) & keys

    params.slice(*permitted_keys)
  end

  def build_meta(scoped)
    {
      total: scoped.size,
      limit: limit,
      offset: offset
    }
  end

  def build_data(scoped)
    scoped = paginate(scoped)
    scoped
  end

  def paginate(scoped)
    scoped.limit(limit).offset(offset)
  end
end
