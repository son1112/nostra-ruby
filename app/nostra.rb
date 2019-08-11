# require './config.rb'
# require './nostra/relations/accounts.rb'
# require './nostra/repositories/accounts.rb'
require_relative './nostra/constants.rb'
require_relative './nostra/account.rb'

module Nostra
  def self.import_csv(csv_file)
      add_by_csv(csv_file)
  end

  private

  def self.add_by_csv(csv_file)
    transaction_rows = CSVDataParser.transactions(csv_file)
    add_transactions_by_account(transaction_rows)
  end

  def self.add_transactions_by_account(transaction_rows)
    transactions_by_account = sort_by_from_account(transaction_rows)

    transactions_by_account.each do |name, transactions|
      new_account = Nostra::Account.new(name)
      new_account.add_transactions(transactions)
    end
  end

  def self.sort_by_from_account(transaction_rows)
    sorted_transactions = transaction_rows.sort_by { |transaction| transaction[:from_account] }

    collection = sorted_transactions.group_by { |transaction|
      transaction[:from_account]
    }

    collection
  end
end
