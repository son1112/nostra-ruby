# require './config.rb'
# require './nostra/relations/accounts.rb'
# require './nostra/repositories/accounts.rb'
require_relative './nostra/constants.rb'
require_relative './nostra/account.rb'

module Nostra
  def self.import_csv(csv_file, type = :one_money)
    case type
    when :one_money
      add_by_csv(csv_file)
    else
      raise "#{type} csv not implemented for import!"
    end
  end

  private

  def self.add_by_csv(csv_file)
    transaction_rows = CSVDataParser.transactions(csv_file)
    add_transactions_by_account(transaction_rows)
  end

  def self.add_transactions_by_account(transaction_rows)
    transactions_by_account = sort_by_from_account(transaction_rows)

    transactions_by_account.each do |account|
      new_account = Nostra::Account.new(account[:name])
      new_account.add_transactions(account[:transactions])
    end
  end

  def self.sort_by_from_account(transaction_rows)
    sorted_transactions = transaction_rows.sort_by { |transaction| transaction[:from_account] }

    collection = []
    account_names = (sorted_transactions.each.collect { |transaction| transaction[:from_account] }).uniq

    account_names.each { |account|
      account_transactions = sorted_transactions.select { |transaction|
        transaction[:from_account] == account
      }
      collection << {
        name: account,
        transactions: account_transactions
      }
    }

    collection
  end
end
