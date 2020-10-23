require 'rails_helper'

RSpec.describe 'Merchants API Request' do
  it 'imports a merchant list' do
    create_list(:merchant, 5)
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants[:data].size).to eq(5)
    merchant_hash = merchants[:data]
    merchant_hash.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String
      expect(merchant[:attributes]).to have_key(:created_at)
      expect(merchant[:attributes][:created_at]).to be_a String
      expect(merchant[:attributes]).to have_key(:updated_at)
      expect(merchant[:attributes][:updated_at]).to be_a String
    end

  end
  it 'can find merchant by id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant_data = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_data[:data]

    expect(merchant).to have_key(:id)
    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a String
    expect(merchant[:attributes]).to have_key(:created_at)
    expect(merchant[:attributes][:created_at]).to be_a String
    expect(merchant[:attributes]).to have_key(:updated_at)
    expect(merchant[:attributes][:updated_at]).to be_a String
  end

  it 'can create an merchant record' do
    merchant_params = ({
      name: 'Blouse Barn',
      id: 1,
      created_at: '04-06-2020 12:16:17 UTC',
      updated_at: '04-06-2020 12:16:17 UTC'
      })

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant_params)
      created_merchant = Merchant.last
      expect(response).to be_successful

      expect(created_merchant.name).to eq(merchant_params[:name])
      expect(created_merchant.created_at).to eq(merchant_params[:created_at])
      expect(created_merchant.updated_at).to eq(merchant_params[:updated_at])
  end

  it "can update an merchant record" do
    merchant = Merchant.create!({
      name: 'Blouse Barn',
      id: 1,
      created_at: '04-06-2020 12:16:17 UTC',
      updated_at: '04-06-2020 12:16:17 UTC'
      })
    name = Merchant.last.name
    merchant_params = { name: 'Blouse House' }
    headers = {"CONTENT_TYPE" => 'application/json'}

    patch "/api/v1/merchants/#{merchant.id}", headers: headers, params: JSON.generate(merchant_params)
    new_merchant = Merchant.find_by(id: merchant.id)

    expect(response).to be_successful
    expect(new_merchant.name).to_not eq(name)
    expect(new_merchant.name).to eq('Blouse House')
  end

  it "can destroy an merchant record" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can import items related to merchant" do
    create_list(:merchant, 2)
    expect(Merchant.count).to eq(2)
    merchant = Merchant.first
    merchant2 = Merchant.last

    create_list(:item, 5, merchant: merchant)
    create_list(:item, 3, merchant: merchant2)

    expect(merchant.items.count).to eq(5)
    expect(merchant2.items.count).to eq(3)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq(merchant.items.count)
  end


  it 'can find a merchant by its id' do
    merchant_object = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant_object.id}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_json[:data][:attributes]
    expect(merchant_object.id).to eq(merchant[:id])
  end

  it 'can find a merchant by its name' do
    merchant_object = create(:merchant)

    get "/api/v1/merchants/find?name=#{merchant_object.name}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_json[:data][:attributes]
    expect(merchant_object.name).to eq(merchant[:name])
  end

  xit 'can find a merchant by its created_at' do
    merchant_object = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{merchant_object.created_at}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_json[:data][:attributes]
    expect(merchant_object.created_at).to eq(merchant[:created_at])
  end

  xit 'can find a merchant by its updated_at' do
    merchant_object = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{merchant_object.updated_at}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)
    merchant = merchant_json[:data][:attributes]
    expect(merchant_object.updated_at).to eq(merchant[:updated_at])
  end

  it 'can find multiple merchants by its name' do
    merchant_object = create(:merchant, name: "Starbies")
    merchant_object2 = create(:merchant, name: "Rockstar Bar")
    merchant_object3 = create(:merchant, name: "Food N' Stuff")
    get "/api/v1/merchants/find_all?name=Star"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)

    merchant = merchant_json[:data]

    expect(merchant.count).to eq(2)
  end

  xit 'can find multiple merchants by its created_at' do
    merchant_object = create(:merchant)
    merchant_object2 = create(:merchant, created_at: merchant_object.created_at)
    merchant_object3 = create(:merchant)
    get "/api/v1/merchants/find_all?created_at=#{merchant_object.created_at}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)

    merchant = merchant_json[:data]

    expect(merchant.count).to eq(2)
  end

  xit 'can find multiple merchants by its updated_at' do
    merchant_object = create(:merchant)
    merchant_object2 = create(:merchant, created_at: merchant_object.updated_at)
    merchant_object3 = create(:merchant)
    get "/api/v1/merchants/find_all?updated_at=#{merchant_object.updated_at}"

    expect(response).to be_successful

    merchant_json = JSON.parse(response.body, symbolize_names: true)

    merchant = merchant_json[:data]

    expect(merchant.count).to eq(2)
  end
end
