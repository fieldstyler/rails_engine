class Api::V1::Items::FindController < ApplicationController

  def index
    if params.keys.first == "unit_price" || params.keys.first == "merchant_id"
      render json: ItemSerializer.new(Item.where("#{item_params.keys[0]} = #{item_params[item_params.keys[0]]}"))
    elsif
      render json: ItemSerializer.new(Item.where("#{item_params.keys[0]} ILIKE ?", "%#{item_params[item_params.keys[0]]}%"))
    end
  end

  def show
    render json: ItemSerializer.new(Item.find_by('name ILIKE ?', "%#{item_params[:name]}%"))
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
