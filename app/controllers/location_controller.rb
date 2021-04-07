class LocationController < ApplicationController

  def index
    locations, meta = LocationService.search(Location.all, resource_params)
    render_serializer(locations.to_a, current_serializer, meta:meta)
  end

  def create
    return unless valid?(current_normalizer)

    result = LocationService.create(resource_params)
    render_serializer(result, current_serializer, status: 201)
  end

  def update
    return unless valid? current_normalizer
    return not_found if current_resource.new_record?

    location = LocationService.update(current_resource, resource_params)
    render_serializer(location, current_serializer)
  end

  def destroy
    return not_found if current_resource.new_record?
    location = LocationService.destroy(current_resource)
    render_serializer(location, current_serializer)
  end

  private

  def current_normalizer
    @current_normalizer ||= LocationNormalizer.new(params)
  end

  def resource_params
    current_normalizer.permitted_attributes.to_h
  end

  def current_resource
    @resource ||= resource_lookup(Location)
  end

  def current_serializer
    LocationSerializer
  end
end