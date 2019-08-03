require 'byebug'
require './nostra.rb'

account = Nostra::Account.new

expense_data = { amount: 200, type: :expense }
income_data = { amount: 500, type: :income }

transactions = [expense_data, income_data]

account.add_transactions(transactions)

puts account.expense_total
puts account.income_total
puts account.balance
