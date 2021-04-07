RSpec::Matchers.define :have_concern do |expected|
  match do |object|
    object.class.ancestors.include?(expected)
  end

  failure_message do |actual|
    "expected #{actual.class.ancestors} to include concern #{expected}"
  end
end

RSpec::Matchers.define :be_child_of do |expected|
  match do |object|
    object.superclass == expected
  end

  failure_message do |actual|
    "expected #{actual.class.ancestors} to be inherited from #{expected}"
  end
end
