module LocationService
  class Update < ApplicationService
    attr_reader :location, :params
    def initialize(location, params)
      @location = location
      @params = params
    end

    def perform
      location.name = params[:name]
      location.code = params[:code]
      location.save!
      location
    rescue StandardError => e
      raise e
    end
  end
end