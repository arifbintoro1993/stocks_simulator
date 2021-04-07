require 'rails_helper'

RSpec.describe LocationService::Search do
  let!(:location1) { create(:location) }
  let!(:location2) { create(:location, name: "Bandung") }
  let!(:location3) { create(:location, code: "location-jakarta-code-0001") }

  subject { LocationService.search(Location.all, params) }

  describe '#perform' do
    context 'get all locations' do
      let(:params) { {} }
      it 'get all' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 3
      end
    end

    context 'get locations with offset' do
      let(:params) { {offset: 1} }
      it 'filter' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 2
      end
    end

    context 'get location by name' do
      let(:params) { {name: 'ban'} }

      it 'filter' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 1
        expect(subject[0].first.name).to eq location2.name
      end
    end
    
  end
end