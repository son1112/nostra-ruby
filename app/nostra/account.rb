require_relative './date_helper.rb'
require_relative './account/account_helper.rb'
require_relative './transaction.rb'

module Nostra
  class Account
    attr_accessor :transactions
    attr_accessor :name
    attr_accessor :type
    attr_reader :date

    include Nostra::AccountHelper
    include Nostra::DateHelper

    def initialize
      @transactions ||= []
      @date = Date.today
    end

    def balance(date = Date.today)
      unless date.is_a?(Date)
        @date = parse_date(date)
      end
      income_total - expense_total
    end

    def incomes
      incomes = transactions_filtered_by_date.select { |transaction|
        transaction.is_a?(Income)
      }

      return incomes
    end

    def expenses
      expenses = transactions_filtered_by_date.select { |transaction|
        transaction.is_a?(Expense)
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

    def reset
      @transactions = []
    end

    private

    def transaction_collection
      transactions_filtered_by_date.collect { |transaction|
        if transaction.recurring
          transaction.get_recurring(@date)
        else
          transaction
        end
      }
    end

    def transactions_filtered_by_date
      transactions = @transactions.select { |transaction|
        transaction.date <= @date
      }

      return transactions
    end
  end
end

