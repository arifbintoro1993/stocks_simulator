require 'rails_helper'

RSpec.describe LocationService::Destroy do
  let!(:location) { create(:location) }

  subject { LocationService.destroy(location) }

  describe '#perform' do
    context 'destroy location' do
      it 'return status success' do
        expect { subject }.not_to raise_error
      end
    end
  end
end