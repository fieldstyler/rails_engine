FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { Faker::Name.status }
    created_at { Faker::Name.created_at }
    updated_at { Faker::Name.updated_at }
  end
end
