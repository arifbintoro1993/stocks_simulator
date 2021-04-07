module LocationService
  class Destroy < ApplicationService
    attr_reader :location

    def initialize(location)
      puts location
      @location = location
    end

    def perform
      location.destroy!
    rescue StandardError => e
      raise e
    end
  end
end