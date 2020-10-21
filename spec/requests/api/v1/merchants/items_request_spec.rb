require 'rails_helper'

RSpec.describe 'Items API Request' do
  it 'imports an item list' do
    create(:merchant)
    merchant = Merchant.first
    create_list(:item, 5, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.size).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an Integer
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a String
      expect(item).to have_key(:description)
      expect(item[:description]).to be_a String
      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a Float
      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_a String
      expect(item).to have_key(:created_at)
      expect(item[:created_at]).to be_a String
      expect(item).to have_key(:updated_at)
      expect(item[:updated_at]).to be_a String
    end
  end

end
