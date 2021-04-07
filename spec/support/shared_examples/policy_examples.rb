RSpec.shared_examples 'should allow access' do
  it 'return okay' do
    allowed_action.each do |action|
      is_expected.to be_able_to(action)
    end
  end
end

RSpec.shared_examples 'should forbid access' do
  it 'return forbidden' do
    forbidden_action.each do |action|
      is_expected.not_to be_able_to(action)
    end
  end
end
