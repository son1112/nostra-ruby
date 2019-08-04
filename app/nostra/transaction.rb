require_relative './date_helper.rb'
require_relative './transaction/transaction_helper.rb'

module Nostra
  class Transaction
    attr_accessor :amount
    attr_accessor :date
    attr_accessor :recurring

    include Nostra::TransactionHelper
    include Nostra::DateHelper

    def initialize(params = {})
      @amount = params[:amount] || 0 # Int
      @date = params[:date] ? parse_date(params[:date]) : Date.today
      @recurring = params[:recurring] # Nostra::RecurringType
    end
  end

  class Expense < Transaction
  end

  class Income < Transaction
  end

  class Transfer < Transaction
  end
end
