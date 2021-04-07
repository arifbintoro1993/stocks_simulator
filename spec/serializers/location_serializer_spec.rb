require 'rails_helper'

RSpec.describe LocationSerializer do
  let(:object) { build_stubbed :location, name: "Location Name", code: "location-name-code-001" }
  let(:options) { {} }
  let(:serializer) { ActiveModelSerializers::SerializableResource.new(object, options.merge(serializer: described_class)) }

  subject { serializer.serializable_hash }
  it { expect(described_class).to be_child_of(ApplicationSerializer) }

  it { is_expected.to validate_json_schema('locations') }

  it { is_expected.to include(id: object.id) }
  it { is_expected.to include(name: 'Location Name') }
  it { is_expected.to include(code: 'location-name-code-001') }


end