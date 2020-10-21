FactoryBot.define do
  factory :customer do
    first_name { Faker::Customer.first_name }
    last_name { Faker::Customer.last_name }
    created_at { Faker::Customer.created_at }
    updated_at { Faker::Customer.updated_at }
  end
end
