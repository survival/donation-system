# frozen_string_literal: true

require 'date'
require 'money'
require 'uri'

module DonationSystem
  class Utils
    SALESFORCE_TIME_FORMAT = '%Y-%m-%d'

    def generate_number(number_prefix)
      number_prefix + Array.new(9) { Random.rand(9) }.join
    end

    def number?(string)
      number(string)
    rescue ArgumentError
      false
    end

    def number(string)
      BigDecimal(string)
    end

    def currency?(string)
      currency_in_uppercase(string)
    rescue Money::Currency::UnknownCurrency
      false
    end

    def date?(string)
      Date.parse(string)
    rescue ArgumentError
      false
    end

    def url?(url)
      url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
    end

    def format_date(date)
      return Time.at(date).strftime(SALESFORCE_TIME_FORMAT) if integer?(date)
      Date.parse(date).strftime(SALESFORCE_TIME_FORMAT)
    end

    def amount_in_cents(amount, currency)
      return money_from_cents(amount, currency).cents if integer?(amount)
      money_from_text(amount, currency).cents
    end

    def amount_in_currency_units(amount, currency)
      return money_from_cents(amount, currency).to_s if integer?(amount)
      money_from_text(amount, currency).to_s
    end

    def currency_in_uppercase(currency)
      Money::Currency.new(currency).to_s
    end

    private

    def integer?(number)
      Integer(number)
    rescue ArgumentError
      false
    end

    def money_from_cents(amount, currency)
      I18n.enforce_available_locales = false
      Money.new(amount, currency)
    end

    def money_from_text(amount, currency)
      I18n.enforce_available_locales = false
      amount_as_number = number(amount).abs
      Money.from_amount(amount_as_number, currency)
    end
  end
end
