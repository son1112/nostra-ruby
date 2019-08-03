module Nostra
  module AccountHelper
    def add_transactions(transactions_data)
      transactions_data.each { |transaction_data|
        add_transaction(transaction_data)
      }
    end

    private

    def add_transaction(transaction_data)
      case transaction_data[:type]
      when :expense
        add_expense(transaction_data)
      when :income
        add_income(transaction_data)
      else
        raise "unsupported transaction type!"
      end
    end

    def add_expense(transaction_data)
      transaction = Nostra::Expense.new(transaction_data)
      @transactions << transaction
    end

    def add_income(transaction_data)
      transaction = Nostra::Income.new(transaction_data)
      @transactions << transaction
    end

    def remove_transaction(transaction)
    end

    def edit_transaction(transaction)
    end
  end
end
