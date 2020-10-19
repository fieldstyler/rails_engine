class Invoice < ApplicationRecord
    validates_presence_of :customer_id
    validates_presence_of :merchant_id
    validates_presence_of :status
    validates_presence_of :created_at
    validates_presence_of :updated_at
end
