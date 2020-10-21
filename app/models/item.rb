class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :merchant_id
  validates_presence_of :created_at
  validates_presence_of :updated_at
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.top_items(limit = 10)
    select("items.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS revenue")
    .joins(:invoice_items, :transactions)
    .group(:id)
    .merge(Transaction.unscoped.successful)
    .order("revenue DESC")
    .limit(limit)
  end
end
