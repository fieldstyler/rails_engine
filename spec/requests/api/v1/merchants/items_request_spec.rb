require 'rails_helper'

RSpec.describe 'Items API Request' do
  it 'imports an item list' do
    create(:merchant)
    merchant = Merchant.first
    create_list(:item, 5, merchant_id: merchant.id)
    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].size).to eq(5)
    item_hash = items[:data]
    item_hash.each do |item|

      expect(item).to have_key(:id)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an Integer
      expect(item[:attributes]).to have_key(:created_at)
      expect(item[:attributes][:created_at]).to be_a String
      expect(item[:attributes]).to have_key(:updated_at)
      expect(item[:attributes][:updated_at]).to be_a String
    end

  end
  it 'can find item by id' do
    create(:merchant)
    faker_item = create(:item)
    id = faker_item.id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(faker_item).to have_key(:id)
    expect(faker_item.id).to be_an Integer
    expect(faker_item.name).to be_a String
    expect(faker_item.description).to be_a String
    expect(faker_item.unit_price).to be_a Float
    expect(faker_item.merchant_id).to be_an Integer
    expect(faker_item.created_at).to be_a Time
    expect(faker_item.updated_at).to be_a Time
  end
end
