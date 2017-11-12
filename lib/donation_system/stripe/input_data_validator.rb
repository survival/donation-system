# frozen_string_literal: true

require 'stripe/result'

module Stripe
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
        amount: data.amount,
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
      :missing_amount unless data&.amount
    end

    def validate_currency
      :missing_currency unless data&.currency
    end

    def validate_token
      :missing_token unless data&.token
    end

    def validate_email
      :missing_email unless data&.email
    end
  end
end
