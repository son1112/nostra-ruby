require_relative './nostra/constants.rb'
require_relative './nostra/helpers/csv_data_parser'
require_relative './nostra/helpers/account/account_helper.rb'
require_relative './nostra/models/account.rb'
require_relative './nostra/models/transaction.rb'

module Nostra
  module Importer
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
        account = if Nostra::AccountHelper.account_exists?(name)
                    Nostra::Account.find_by(name: name)
                  else
                    Nostra::Account.create({name: name})
                  end

        account.add_transactions(transactions)
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
end
