class Api::V1::Items::FindController < ApplicationController

  def show
    render json: ItemSerializer.new(Item.find_by('name ILIKE ?', "%#{item_params[:name]}%"))
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
