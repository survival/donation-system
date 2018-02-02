# frozen_string_literal: true

require 'money'
require 'uri'

module DonationSystem
  class CreatorDataValidator
    def self.execute(data)
      new(data).execute
    end

    def initialize(data)
      @data = data
    end

    def execute
      validation = Validation.new
      validation << validate_data
      validation << validate_amount
      validation << validate_currency
      validation << validate_return_url
      validation << validate_cancel_url
      validation
    end

    private

    attr_reader :data

    def validate_data
      :missing_data unless data
    end

    def validate_amount
      :invalid_amount unless data&.amount && number?(data.amount) &&
                             number(data.amount).positive?
    end

    def validate_currency
      :invalid_currency unless data&.currency && currency?
    end

    def validate_return_url
      :invalid_return_url unless data&.return_url && valid_url?(data.return_url)
    end

    def validate_cancel_url
      :invalid_cancel_url unless data&.cancel_url && valid_url?(data.cancel_url)
    end

    def number?(string)
      number(string)
    rescue ArgumentError
      false
    end

    def number(string)
      BigDecimal(string)
    end

    def currency?
      Money::Currency.new(data.currency)
    rescue Money::Currency::UnknownCurrency
      false
    end

    def valid_url?(url)
      url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
    end

    class Validation
      attr_reader :errors

      def initialize
        @errors = []
      end

      def <<(error)
        errors << error if error
      end

      def okay?
        errors.empty?
      end
    end
  end
end
