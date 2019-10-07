require 'bigdecimal'
require_relative './date_helper.rb'
require_relative './account/account_helper.rb'

module Nostra
  module CSVDataParser
    def self.transactions(csv_file_multipart_hash)
      csv_file = csv_file_multipart_hash[:tempfile].open
      transactions_data = parse_csv_data(csv_file)
    end

    private

    def self.parse_csv_data(csv_file)
      csv_data = strip_bom_characters(csv_file)
      transaction_rows = collect_transactions(csv_data)[1..-1]

      data_for_transactions = []

      transaction_rows.each do |transaction|
        fields = fields_for_transaction(transaction)

        transaction_data =   {
          title: fields[:title],
          transaction_date: fields[:transaction_date],
          transaction_type: fields[:transaction_type].downcase.to_sym,
          from_account: fields[:from_account],
          to_account: fields[:to_account],
          amount: Nostra::AccountHelper.amount_to_cents(fields[:amount_1]),
          amount_2: fields[:amount_2],
          description: fields[:description]
        }

        unless fields[:transaction_type] == "Transfer"
          transaction_data.merge!({category: fields[:to_account]})
        end

        data_for_transactions << transaction_data
      end

      data_for_transactions
    end


    def self.strip_bom_characters(csv_file)
      bom_chars = "\xEF\xBB\xBF"
      csv_string = File.read(csv_file).force_encoding("UTF-8").gsub("\"", "")
      csv_string.gsub(bom_chars.force_encoding("UTF-8"), '').split("\n")
    end

    def self.collect_transactions(csv_data)
      transaction_rows = []

      csv_data.each do |row|
        break if row == ","
        transaction_rows << row
      end

      transaction_rows
    end

    def self.fields_for_transaction(transaction_string)
      fields = transaction_string.split(',')

      transaction_date = Nostra::DateHelper.parse_date(fields[0])
      transaction_type = fields[1]
      from_account = fields[2]
      to_account = fields[3]
      amount_1 = fields[4]
      amount_2 = fields[6]
      description = fields[9]
      title = "#{from_account}_#{to_account} #{transaction_type} #{amount_1} #{transaction_date}"

      {
        title: title,
        transaction_date: transaction_date,
        transaction_type: transaction_type,
        from_account: from_account,
        to_account: to_account,
        amount_1: amount_1,
        amount_2: amount_2,
        description: description
      }
    end
  end
end
