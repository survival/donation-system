# frozen_string_literal: true

require 'money'
require_relative 'result'

module DonationSystem
  class InputDataValidator
    VALID_TYPES = { oneoff: 'one-off', recurring: 'recurring' }.freeze

    def self.execute(data)
      new(data).execute
    end

    def initialize(data)
      @data = data
    end

    def execute
      validation = Validation.new
      validation << validate_data
      validation << validate_type
      validation << validate_amount
      validation << validate_currency
      validation << validate_token
      validation << validate_email
      validation
    end

    private

    attr_reader :data

    def validate_data
      :missing_data unless data
    end

    def validate_type
      :invalid_donation_type unless data&.type &&
                                    VALID_TYPES.values.include?(data.type)
    end

    def validate_amount
      :invalid_amount unless data&.amount && number?(data.amount) &&
                             number(data.amount).positive?
    end

    def validate_currency
      :invalid_currency unless data&.currency && currency?
    end

    def validate_token
      :missing_token unless data&.token
    end

    def validate_email
      :missing_email unless data&.email
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
