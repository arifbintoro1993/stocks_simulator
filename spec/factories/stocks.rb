FactoryBot.define do
  factory :stock do
    product { create(:product) }
    location { create(:location) }
  end
end
