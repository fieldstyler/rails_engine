class Merchant < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :created_at
  validates_presence_of :updated_at

  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
end
