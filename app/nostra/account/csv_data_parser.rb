module Nostra
  module CSVDataParser
    def self.transactions(csv_file)
      transactions_data = parse_csv_data(csv_file)
    end

    private

    def self.parse_csv_data(csv_file)
      csv_data = strip_bom_characters(csv_file)
      transaction_rows = collect_transactions(csv_data)[1..-1]

      transactions_data = []

      transaction_rows.each do |transaction|
        fields = fields_for_transaction(transaction)

        transaction_data =   {
          date: fields[:date],
          type: fields[:type].downcase.to_sym,
          from_account: fields[:from_account],
          to_account: fields[:to_account],
          amount_1: fields[:amount_1],
          amount_2: fields[:amount_2],
          notes: fields[:notes]
        }

        unless fields[:type] == "Transfer"
          transaction_data.merge!({category: fields[:to_account]})
        end

        transactions_data << transaction_data
      end

      transactions_data
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

      date = fields[0]
      type = fields[1]
      from_account = fields[2]
      to_account = fields[3]
      amount_1 = fields[4]
      amount_2 = fields[6]
      notes = fields[9]

      {
        date: date,
        type: type,
        from_account: from_account,
        to_account: to_account,
        amount_1: amount_1,
        amount_2: amount_2,
        notes: notes
      }
    end
  end
end
