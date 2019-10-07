Nostra::Account.delete_all
Nostra::Transaction.delete_all

Nostra::Account.create(
  id: 1,
  name: 'Test Account',
  account_type: 'Checking'
)

Nostra::Transaction.create(
  id: 1,
  title: 'Water bill',
  description: 'bi-monthly water utility bill',
  amount: 8226,
  transaction_date: Date.today,
  transaction_type: 'expense',
  recurring_type: 'bi-monthly',
  account_id: 1
)

accounts = Nostra::Account.all
transactions = Nostra::Transaction.all

puts "Seeded the following..."
puts "Nostra Accounts: #{accounts.count}"
puts "Nostra Transactions: #{transactions.count}"
