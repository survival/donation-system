# frozen_string_literal: true

require 'money'
require_relative 'result'

module DonationSystem
  module StripeWrapper
    class InputDataValidator
      def self.execute(data)
        new(data).execute
      end

      def initialize(data)
        @data = data
      end

      def execute
        Result.new(fields, errors)
      end

      private

      attr_reader :data

      def fields
        return unless errors.empty?
        {
          amount: amount_in_cents,
          currency: data.currency,
          source: data.token,
          description: "Charge for #{data.email}"
        }
      end

      def errors
        validation_errors = []
        validation_errors << validate_data
        validation_errors << validate_amount
        validation_errors << validate_currency
        validation_errors << validate_token
        validation_errors << validate_email
        validation_errors.compact
      end

      def validate_data
        :missing_data unless data
      end

      def validate_amount
        :invalid_amount unless data&.amount && number?
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

      def amount_in_cents
        Money.from_amount(BigDecimal(data.amount).abs, data.currency).cents
      end

      def number?
        BigDecimal(data.amount)
      rescue ArgumentError
        false
      end

      def currency?
        Money::Currency.new(data.currency)
      rescue Money::Currency::UnknownCurrency
        false
      end
    end
  end
end
