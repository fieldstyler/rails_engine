class AddTransactionsToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :transaction, foreign_key: true
  end
end
