FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Name.customer_id }
    merchant_id { Faker::Name.merchant_id }
    status { Faker::Name.status }
  end
end
