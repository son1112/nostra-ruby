require_relative '../helpers/date_helper.rb'
require_relative '../helpers/transaction/transaction_helper.rb'

module Nostra
  class Transaction < ActiveRecord::Base
    belongs_to :account

    # attr_accessor :title
    # attr_accessor :description
    # attr_accessor :amount
    # attr_accessor :transaction_date
    # attr_accessor :recurring_type

    # include Nostra::TransactionHelper
    # include Nostra::DateHelper

    # def initialize(params = {})
    #   @amount = params[:amount] || 0 # Int
    #   @date = params[:date] ? parse_date(params[:date]) : Date.today
    #   @recurring_type = params[:recurring_type] # Nostra::RecurringType
    # end
  end

  class Expense < Transaction
  end

  class Income < Transaction
  end

  class Transfer < Transaction
  end
end
