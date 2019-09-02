require 'date'

module Nostra
  module DateHelper
    def self.parse_date(date)
      return date if date.is_a?(Date)
      return Date.strptime(date, "%m/%d/%y")

      year, month, day = date[0], date[1], date[2]
      date_string = date.join('-')

      unless Date.valid_date?(year, month, day)
        raise "invalid date! #{date_string}"
      end

      Date.parse(date_string)
    end
  end
end
