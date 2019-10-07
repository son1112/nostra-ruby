require_relative '../csv_data_parser'

module Nostra
  module AccountHelper
    def add_transactions(transactions_data)
      transactions_data.each { |transaction_data|
        transaction_data.merge!({account_id: self.id})
        add_transaction(transaction_data)
      }
    end

    def format_dollar_amount(cents)
      cents/100.0
    end

    def self.amount_to_cents(amount)
      (BigDecimal(amount) * 100).round
    end

    def self.account_exists?(name)
      !Nostra::Account.find_by(name: name).nil?
    end

    private

    def add_transaction(transaction_data)
      transaction_type = transaction_data[:transaction_type]

      case transaction_type
      when :expense
        add_expense(transaction_data)
      when :income
        add_income(transaction_data)
      when :transfer
        add_transfer(transaction_data)
      else
        puts "Unsupported transaction type #{transaction_type}!"
      end
    end

    def add_expense(transaction_data)
      Nostra::Expense.create(transaction_data)
    end

    def add_income(transaction_data)
      Nostra::Income.create(transaction_data)
    end

    def add_transfer(transaction_data)
      Nostra::Transfer.create(transaction_data)
    end

    def remove_transaction(transaction)
    end

    def edit_transaction(transaction)
    end
  end
end
