require 'rails_helper'

RSpec.describe ProductService::Destroy do
  let!(:product) { create(:product) }

  subject { ProductService.destroy(product) }

  describe '#perform' do
    context 'destroy product' do
      it "status success" do
        expect { subject }.not_to raise_error
      end
    end
  end
end