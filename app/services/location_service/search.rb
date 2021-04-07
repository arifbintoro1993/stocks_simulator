module LocationService
  class Search < ApplicationService
    attr_reader :params
    include Queryable

    def initialize(model_query, params)
      @model_query = model_query
      @params = params
    end

    def perform
      call_query(@model_query, @params)
    end

    def build_query(model_query, params, _range_query)
      query = model_query.where(params.except(:name, :offset, :limit, :sort))
      query = query.where('lower(name) like lower(?)', "%#{params[:name]}%") if params[:name].present?
      query
    end
  end
end