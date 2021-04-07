module LocationService
  class Create < ApplicationService
    def initialize(params)
      @name = params[:name]
      @code = params[:code]
    end

    def perform
      location = Location.create!(
        name: @name,
        code: @code
      )

      location
    end
  end
end