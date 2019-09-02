module Nostra
  module TransactionHelper
    def next_transaction_date(from_date = self.date)
      case recurring
      when :daily
        date + 1
      when :weekly
        date + 7
      when :bi_weekly
        date + 14
      when :monthly
        date >> 1
      when :bi_monthly
        date >> 2
      when :tri_monthly
        date >> 3
      when :yearly
        date >> 12
      else
        raise "recurring type not supported!"
      end
    end

    def get_recurring(up_to_date)
      return transaction unless recurring

      transaction_collection = [self]

      current_transaction_date = date

      while current_transaction_date <= up_to_date
        transaction_collection << Transaction.new(
          {
            amount: self.amount,
            date: next_transaction_date(self.date)
          }
        )
        current_transaction_date = next_transaction_date(self.date)
      end

      transaction_collection
    end
  end
end
