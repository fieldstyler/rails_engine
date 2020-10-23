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

  it 'can import the merchant associated with a specific item' do
    item = create(:item)

    expect(item.merchant).to be_a(Merchant)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)

    merchant = merchant_json[:data][:attributes]

    expect(merchant).to have_key(:id)
    expect(item.merchant.id).to eq(merchant[:id])
    expect(merchant).to have_key(:name)
    expect(merchant).to have_key(:created_at)
    expect(merchant).to have_key(:updated_at)
  end

  it 'can find an item by its id' do
    item_object = create(:item)

    get "/api/v1/items/find?id=#{item_object.id}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]
    expect(item_object.id).to eq(item[:id])
  end

  it 'can find an item by its name' do
    item_object = create(:item)

    get "/api/v1/items/find?name=#{item_object.name}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]
    expect(item_object.name).to eq(item[:name])
  end

  it 'can find an item by its description' do
    item_object = create(:item)
    item_object2 = create(:item)

    get "/api/v1/items/find?description=#{item_object.description}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]
    expect(item_object.description).to eq(item[:description])

    expect(item_json.count).to eq(1)
  end

  it 'can find an item by its unit_price' do
    item_object = create(:item)

    get "/api/v1/items/find?unit_price=#{item_object.unit_price}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]
    expect(item_object.unit_price).to eq(item[:unit_price])
    expect(item_json.count).to eq(1)
  end

  xit 'can find an item by its created_at' do
    item_object = create(:item)

    get "/api/v1/items/find?created_at=#{item_object.created_at}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]

    expect(item_object.created_at).to eq(item[:created_at])
  end

  xit 'can find an item by its updated_at' do
    item_object = create(:item)

    get "/api/v1/items/find?updated_at=#{item_object.updated_at}"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)
    item = item_json[:data][:attributes]

    expect(item_object.updated_at).to eq(item[:updated_at])
  end

  it 'can find multiple items by its name' do
    item_object = create(:item, name: "Dog")
    item_object2 = create(:item, name: "Doggy Door")
    item_object3 = create(:item, name: "Cat House")
    get "/api/v1/items/find_all?name=Dog"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)

    item = item_json[:data]

    expect(item.count).to eq(2)
  end

  it 'can find multiple items by its description' do
    item_object = create(:item, description: "Brown")
    item_object2 = create(:item, description: "Brownish")
    item_object3 = create(:item, description: "Redish")
    get "/api/v1/items/find_all?description=Brown"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)

    item = item_json[:data]
    expect(item.count).to eq(2)
  end

  it 'can find multiple items by its unit price' do
    item_object = create(:item, unit_price: 123)
    item_object2 = create(:item, unit_price: 234)
    item_object3 = create(:item, unit_price: 234)
    get "/api/v1/items/find_all?unit_price=234"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)

    item = item_json[:data]
    expect(item.count).to eq(2)
  end

  it 'can find multiple items by its merchant id' do
    create(:merchant, id: 12)
    create(:merchant, id: 23)
    item_object = create(:item, merchant_id: 12)
    item_object2 = create(:item, merchant_id: 23)
    item_object3 = create(:item, merchant_id: 23)
    get "/api/v1/items/find_all?merchant_id=23"

    expect(response).to be_successful

    item_json = JSON.parse(response.body, symbolize_names: true)

    item = item_json[:data]
    expect(item.count).to eq(2)
  end
end
