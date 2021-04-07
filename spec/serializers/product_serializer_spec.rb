require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:object) { build_stubbed :product, name: 'Product Name', sku: "product-name-sku-001" }
  let(:options) { {} }
  let(:serializer) { ActiveModelSerializers::SerializableResource.new(object, options.merge(serializer: described_class)) }

  subject { serializer.serializable_hash }

  it { expect(described_class).to be_child_of(ApplicationSerializer) }

  it { is_expected.to validate_json_schema('products') }
  

  it { is_expected.to include(id: object.id) }
  it { is_expected.to include(name: 'Product Name') }
  it { is_expected.to include(sku: 'product-name-sku-001') }
end
