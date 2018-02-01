# frozen_string_literal: true

require 'date'
require 'money'

module DonationSystem
  class Utils
    SALESFORCE_TIME_FORMAT = '%Y-%m-%d'

    def generate_number(number_prefix)
      number_prefix + Array.new(9) { Random.rand(9) }.join
    end

    def integer?(number)
      Integer(number)
    rescue ArgumentError
      false
    end

    def format_time(seconds_since_epoch)
      Time.at(seconds_since_epoch).strftime(SALESFORCE_TIME_FORMAT)
    end

    def amount_in_currency_units(data)
      I18n.enforce_available_locales = false
      Money.new(data.amount, data.currency).to_s
    end
  end
end
