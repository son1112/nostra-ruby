require_relative '../helpers/date_helper.rb'
require_relative '../helpers/account/account_helper.rb'

module Nostra
  class Account < ActiveRecord::Base
    has_many :transactions

    include Nostra::AccountHelper
    include Nostra::DateHelper

    def balance(date)
      @date = if date
                parse_date(date)
              else
                Date.today
              end

      format_dollar_amount(income_total - expense_total)
    end

    private

    def incomes
      incomes = transactions_filtered_by_date.select { |transaction|
        transaction.transaction_type == 'income'
      }

      return incomes
    end

    def expenses
      expenses = transactions_filtered_by_date.select { |transaction|
        transaction.transaction_type == 'expense'
      }

      return expenses
    end

    def income_total
      incomes.collect { |income|
        income.amount
      }.sum
    end

    def expense_total
      expenses.collect { |expense|
        expense.amount
      }.sum
    end

    def transactions_filtered_by_date
      transactions = self.transactions.select { |transaction|
        transaction.transaction_date <= @date
      }

      return transactions
    end
  end
end

