require 'rails_helper'

RSpec.describe ProductService::Create do
  subject { ProductService.create(params) }

  describe '#perform' do
    context "create new product with valid params" do
      let(:params) do
        {
          "name": "Product Name",
          "sku": "product-name-sku-001"
        }
      end

      it "status success" do
        expect { subject }.not_to raise_error
        expect(subject.name).to eq params[:name]
      end
    end

    context 'create new product with invalid params' do
      let(:params) do
        {
          "name": "Product Name",
          "sku": "sku-001"
        }
      end

      it "status failed" do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  
  end
end