module Sortable
  extend ActiveSupport::Concern

  SORT_DELIMITER = ','.freeze

  def sort(valid_attributes)
    return default_sort unless params[:sort]

    build_sort(valid_attributes)
  end

  private

  def default_sort
    { id: :asc }
  end

  #
  # build order query from params[:sort] only if it is a valid attribute
  #
  # Example:
  #   sort_query == { name: :asc, created_at: :desc }
  #
  def build_sort(valid_attributes)
    sort_query = {}

    params[:sort].split(SORT_DELIMITER).each do |sort_param|
      attribute, direction = build_direction(sort_param)
      next unless valid_attributes.include? attribute

      sort_query[attribute.to_sym] = direction
    end

    return default_sort if sort_query.empty?
    sort_query
  end

  #
  # build attribute sorting order
  #
  # Example:
  #   sort_param = 'name'
  #   will return ['name', :asc]
  #
  #   sort_param = '-created_at'
  #   will return ['created_at', :desc]
  #
  def build_direction(sort_param)
    case sort_param[0]
    when '-' then [sort_param[1..-1], :desc]
    else [sort_param, :asc]
    end
  end
end
