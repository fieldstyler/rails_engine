class Invoice < ApplicationRecord
    validates_presence_of :customer_id
    validates_presence_of :merchant_id
    validates_presence_of :status
    validates_presence_of :created_at
    validates_presence_of :updated_at

    belongs_to :customer
    belongs_to :merchant
    has_many :transactions, dependent: :destroy
    has_many :invoice_items
    has_many :items, through: :invoice_items

    def self.most_revenue(limit = 5)
      select("invoices.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS revenue")
      .joins(:invoice_items, :transactions)
      .group(:id)
      .where(result: "success")
      .order("revenue DESC")
      .limit(limit)
      # .merge(Transaction.unscoped.successful)
    end
end
