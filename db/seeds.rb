# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

Customer.destroy_all
puts 'Creating Customers...'
CSV.foreach('./db/data/customers.csv', headers: true, header_converters: :symbol) do |row|
  Customer.create!({
    id: row[:id],
    first_name: row[:first_name],
    last_name: row[:last_name],
    created_at: row[:created_at],
    updated_at: row[:updated_at]
    })
end
puts 'Customers Successfully Created'

Merchant.destroy_all
puts 'Creating Merchants...'
CSV.foreach('./db/data/merchants.csv', headers: true, header_converters: :symbol) do |row|
  Merchant.create!({
    id: row[:id],
    name: row[:name],
    created_at: row[:created_at],
    updated_at: row[:updated_at]
    })
end
puts 'Merchants Successfully Created'

Invoice.destroy_all
puts 'Creating Invoices...'
CSV.foreach('./db/data/invoices.csv', headers: true, header_converters: :symbol) do |row|
  Invoice.create!({
    id: row[:id],
    customer_id: row[:customer_id],
    merchant_id: row[:merchant_id],
    status: row[:status],
    created_at: row[:created_at],
    updated_at: row[:updated_at]
  })
end
puts 'Invoices Successfully Created'

Item.destroy_all
puts 'Creating Items...'
CSV.foreach('./db/data/items.csv', headers: true, header_converters: :symbol) do |row|
  Item.create!({
    id: row[:id].to_s,
    name: row[:name],
    description: row[:description],
    unit_price: row[:unit_price].to_f / 100,
    merchant_id: row[:merchant_id],
    created_at: row[:created_at],
    updated_at: row[:updated_at]
    })
end
puts 'Items Successfully Created'
InvoiceItem.destroy_all
puts 'Creating Invoice Items...'
CSV.foreach('./db/data/invoice_items.csv', headers: true, header_converters: :symbol) do |row|
  InvoiceItem.create!({
    id: row[:id],
    item_id: row[:item_id],
    invoice_id: row[:invoice_id],
    quantity: row[:quantity],
    unit_price: row[:unit_price].to_f / 100,
    created_at: row[:created_at],
    updated_at: row[:updated_at]
  })
end
puts 'Invoice Items Successfully Created'

Transaction.destroy_all
puts 'Creating Transactions...'
CSV.foreach('./db/data/transactions.csv', headers: true, header_converters: :symbol) do |row|
  Transaction.create!({
    id: row[:id],
    invoice_id: row[:invoice_id],
    credit_card_number: row[:credit_card_number],
    credit_card_expiration_date: row[:credit_card_expiration_date],
    result: row[:result],
    created_at: row[:created_at],
    updated_at: row[:updated_at]
  })
end
puts 'Transactions Successfully Created'
