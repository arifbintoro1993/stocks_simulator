require 'rails_helper'

RSpec.describe ProductService::Update do
  let!(:product) { create(:product) }

  subject { ProductService.update(product, params) }

  describe '#perform' do
    context 'update product with valid params' do
      let(:params) do
        {
          "name": "Product Name",
          "sku": "product-sku-0001"
        }
      end

      it "status success" do
        expect { subject }.not_to raise_error
        expect(subject.name).to eq product.name
      end
    end

    context 'update product with invalid params' do
      let(:params) do
        {
          "name": "Product Name",
          "sku": "product-1"
        }
      end
      it "status failed" do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
    
  end
end
