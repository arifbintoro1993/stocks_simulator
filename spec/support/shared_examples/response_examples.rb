RSpec.shared_examples 'returns error message' do
  specify do
    error_hash = { code: error_code, message: error_msg }
    error_hash[:field] = error_field if respond_to?(:error_field)
    expect(response).to validate_json_schema('errors')
    expect(response).to have_http_status(error_http)
    expect(response).to have_errors(error_hash)
    expect(response).to have_metadata(:http_status, error_http)
  end
end

RSpec.shared_examples 'returns http error' do
  specify do
    expect(response).to have_http_status(error_http)
    expect(response.body).to eq('')
  end
end

RSpec.shared_examples 'conditional get: etag header' do
  specify do
    expect(response).to have_http_status(:ok)
    expect(response.body).not_to eq('')

    etag = response.headers['ETag']
    expect(etag).not_to start_with('W/')
    expect(etag).not_to eq('')

    do_request(:get, 'If-None-Match': etag.delete('"'))

    expect(response).to have_http_status(:not_modified)
    expect(response.body).to eq('')

    new_etag = response.headers['ETag']
    expect(new_etag).not_to start_with('W/')
    expect(new_etag).to eq(etag)
  end
end

RSpec.shared_examples 'unauthorized without valid token' do
  let(:token) { double('token', token: 'unkn0wnt0k3n') }

  it_behaves_like 'returns unauthorized response'
end

RSpec.shared_examples 'not found without valid token' do
  let(:token) { double('token', token: 'unkn0wnt0k3n') }

  it_behaves_like 'returns not found response'
end

RSpec.shared_examples 'returns valid response' do
  it 'returns valid json response' do
    expect(response.status.to_s).to match(/#{(200..202).to_a.join('|')}/)
    expect(response.body.strip).not_to be_empty
    expect(json_decode(response.body)).to be_kind_of(Hash)
  end
end

RSpec.shared_examples 'returns forbidden response' do
  it 'returns forbidden' do
    expect(response).to have_http_status(:forbidden)
    expect(response.body.strip).to be_empty
  end
end

RSpec.shared_examples 'returns accepted response' do
  it 'returns forbidden' do
    expect(response).to have_http_status(:accepted)
    expect(response.body.strip).to be_empty
  end
end

RSpec.shared_examples 'returns unauthorized response' do
  it 'returns unauthorized' do
    expect(response).to have_http_status(:unauthorized)
    expect(response.body.strip).to be_empty
  end
end

RSpec.shared_examples 'returns not found response' do
  it 'returns not found' do
    expect(response).to have_http_status(:not_found)
    expect(response.body.strip).to be_empty
  end
end
