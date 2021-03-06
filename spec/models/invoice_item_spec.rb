require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :item_id}
    it { should validate_presence_of :invoice_id}
    it { should validate_presence_of :quantity}
    it { should validate_presence_of :unit_price}
    it { should validate_presence_of :created_at}
    it { should validate_presence_of :updated_at}
  end
end
