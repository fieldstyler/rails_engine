FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Name.description }
    unit_price { Faker::Name.unit_price }
    merchant_id { Faker::Name.merchant_id }
  end
end
