FactoryBot.define do
  factory :invoice_item do
    item
    invoice
    quantity { Faker::Name.quantity }
    unit_price { Faker::Name.unit_price }
    created_at { Faker::Name.created_at }
    updated_at { Faker::Name.updated_at }
  end
end
