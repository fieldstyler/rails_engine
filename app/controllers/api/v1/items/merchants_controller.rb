class Api::V1::Items::MerchantsController < ApplicationController

  def show
    item = Item.find(params[:id])
    merchant_id = item.merchant_id
    render json: MerchantSerializer.new(Merchant.find(merchant_id))
  end

end
