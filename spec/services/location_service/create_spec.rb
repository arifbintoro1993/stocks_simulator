require 'rails_helper'

RSpec.describe LocationService::Create do
  subject { LocationService.create(params) }

  describe '#perform' do
    context 'create new location with valid params' do
      let(:params) do
        {
          "name": "Location Name",
          "code": "location-name-code-0001"
        }
      end

      it 'return status success' do
        expect { subject }.not_to raise_error
        expect(subject.name).to eq params[:name]
      end
    end

    context 'create new location with invalid params' do
      let(:params) do
        {
          "name": "Location Name",
          "code": "code-01"
        }
      end

      it 'return status failed' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

  end
end