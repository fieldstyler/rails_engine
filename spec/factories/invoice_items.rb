FactoryBot.define do
  factory :invoice_item do
    item_id { Faker::Name.item_id }
    invoice_id { Faker::Name.invoice_id }
    quantity { Faker::Name.quantity }
    unit_price { Faker::Name.unit_price }
    created_at { Faker::Name.created_at }
    updated_at { Faker::Name.updated_at }
  end
end
