FactoryBot.define do
  factory :invoice_item do
    item_id { Faker::Name.item_id }
    invoice_id { Faker::Name.invoice_id }
    quantity { Faker::Name.quantity }
    unit_price { Faker::Name.unit_price }
  end
end
