require 'rails_helper'

RSpec.describe LocationService::Update do
  let(:location) { create(:location) }

  subject { LocationService.update(location, params) }

  describe '#perform' do
    context 'update location with valid params' do
      let(:params) do
        {
          "name": "Location Name Update",
          "code": "location-name-update-code-001"
        }
      end

      it "return status success" do
        expect { subject }.not_to raise_error
        expect(subject.name).to eq location.name
      end
    end

    context 'update location with invalid params' do
      let(:params) do
        {
          "name": "Location Name Update",
          "code": "code-001"
        }
      end

      it 'return status failed' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end