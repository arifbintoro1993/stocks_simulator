require 'rails_helper'

RSpec.describe LocationNormalizer do
  let(:params) { {} }
  let(:normalizer) { described_class.new(ActionController::Parameters.new(params.merge(action: action_name))) }
  let(:location_params) do
    {
      "name": "Location",
      "code": "location-code-0001"
    }
  end

  it {
    expect(described_class).to be_child_of(ApplicationNormalizer) 
  }

  describe '#permitted_attributes' do
    before do
      normalizer.validate
    end

    context 'index' do
      let(:action_name) { :index }
      context ' and valid params' do
        let(:params) { {} }
        let(:expected_attributes) { {} }

        it_behaves_like 'successfully transform attributes'
        it_behaves_like 'returns expected attributes'
      end
    end

    context 'create' do
      let(:action_name) { :create }
      let(:params) { {} }

      context 'and valid params' do
        let!(:params) { location_params }
        let(:expected_attributes) { location_params }

        it_behaves_like 'successfully transform attributes'
        it_behaves_like 'returns expected attributes'
      end

      context 'and invalid params' do
        let(:params) { {} }
        let(:error_messages) do
          {
            name: ["can't be blank"],
            code: ["can't be blank"]
          }
        end

        it_behaves_like 'returns error messages'
      end
    end

    context 'update' do
      let(:action_name) { :update }
      let(:params) { {} }

      context 'and valid params' do
        let!(:params) { location_params }
        let(:expected_attributes) { location_params }

        it_behaves_like 'successfully transform attributes'
        it_behaves_like 'returns expected attributes'
      end
    end
  end
end