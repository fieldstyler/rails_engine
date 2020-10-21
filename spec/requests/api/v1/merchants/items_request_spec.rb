require 'rails_helper'

RSpec.describe 'Items API Request' do
  it 'imports an item list' do
    create_list(:item, 5)
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
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    item_data = JSON.parse(response.body, symbolize_names: true)
    item = item_data[:data]

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

  it 'can create an item record' do
    merchant = create(:merchant)

    item_params = ({
      name: 'Sad Strange Chamaleon',
      id: 1,
      description: 'Like a normal chamaleon, but sad and strange',
      unit_price: 324.24,
      merchant_id: merchant.id,
      created_at: '04-06-2020 12:16:17 UTC',
      updated_at: '04-06-2020 12:16:17 UTC'
      })

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
      created_item = Item.last
      expect(response).to be_successful

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.created_at).to eq(item_params[:created_at])
      expect(created_item.updated_at).to eq(item_params[:updated_at])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an item record" do
    merchant = create(:merchant)
    item = merchant.items.create!({
      name: 'Purple Dog Bowl',
      id: 2,
      description: 'Its purple and dogs can eat out of it',
      unit_price: 12.25,
      created_at: '04-06-2020 12:16:17 UTC',
      updated_at: '04-06-2020 12:16:17 UTC'
      })
    name = Item.last.name
    item_params = { name: 'Blue Dog Bowl' }
    headers = {"CONTENT_TYPE" => 'application/json'}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item_params)
    new_item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(new_item.name).to_not eq(name)
    expect(new_item.name).to eq('Blue Dog Bowl')
  end

  it "can destroy an item record" do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
