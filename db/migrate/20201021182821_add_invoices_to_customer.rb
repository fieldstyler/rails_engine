class AddInvoicesToCustomer < ActiveRecord::Migration[5.2]
  def change
    add_reference :customers, :invoice, foreign_key: true
  end
end
