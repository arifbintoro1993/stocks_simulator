require 'rails_helper'

RSpec.describe Location, type: :model do
  it "location not valid without name" do
    location = Location.new(name: nil, code: "location-code-001")
    expect(location).to_not be_valid
  end

  it "location not valid without code" do
    location = Location.new(name: "Location Name", code: nil)
    expect(location).to_not be_valid
  end

  it "location not valid with code below 10 characters" do
    location = Location.new(name: "Location Name", code: "code")
    expect(location).to_not be_valid
  end

  it "location is valid" do
    location = create(:location)
    expect(location).to be_valid
  end

end
