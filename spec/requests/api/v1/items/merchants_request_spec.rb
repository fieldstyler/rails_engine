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
end
