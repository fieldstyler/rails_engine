class Api::V1::Merchants::FindController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.find_by('name ILIKE ?', "%#{merchant_params[:name]}%"))
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end

end
