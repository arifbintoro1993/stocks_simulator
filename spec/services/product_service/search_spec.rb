require 'rails_helper'

RSpec.describe ProductService::Search do
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product, name: "Makanan") }
  let!(:product3) { create(:product, sku: 'product-sku-1010101010') }

  subject { ProductService.search(Product.all, params) }

  describe '#perform' do
    context 'get all products' do
      let(:params) { {} }
      it 'get all' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 3
      end
    end

    context 'get product with offset' do
      let(:params) { { offset: 1 } }
      it 'filter' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 2
      end
    end

    context 'get product name' do
      let(:params) { { name: 'mak' } }
      it 'filter' do
        expect { subject }.not_to raise_error
        expect(subject[0].size).to eq 1
        expect(subject[0].first.name).to eq product2.name
      end
    end
  end
end
