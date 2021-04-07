RSpec.shared_examples 'successfully transform attributes' do
  specify do
    expect(normalizer).to be_valid
    expect(normalizer.errors.messages).to eq({})
  end
end

RSpec.shared_examples 'returns expected attributes' do
  specify do
    permitted_attributes = ActionController::Parameters.new(
      ActiveSupport::HashWithIndifferentAccess.new(expected_attributes)
    ).permit!

    expect(normalizer.permitted_attributes).to eq permitted_attributes
  end
end

RSpec.shared_examples 'returns error messages' do
  specify do
    expect(normalizer).not_to be_valid
    expect(normalizer.errors.messages).to match_array(error_messages)
  end
end
