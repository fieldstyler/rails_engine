FactoryBot.define do
  factory :transaction do
    invoice_id { Faker::Name.invoice_id }
    credit_card_number { Faker::Name.credit_card_number }
    result { Faker::Name.result }
    created_at { Faker::Name.created_at }
    updated_at { Faker::Name.updated_at }
  end
end
