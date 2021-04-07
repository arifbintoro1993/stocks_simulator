module Paginatable
  extend ActiveSupport::Concern

  def limit
    @limit ||=
      begin
        limit = params.fetch(:limit, 20).to_i
        limit = 5 if limit < 5
        limit = 100 if limit > 100
        limit
      end
  end

  def offset
    @offset ||= params.fetch(:offset, 0).to_i
  end

  def page
    (offset / limit) + 1
  end
end
