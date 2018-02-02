# frozen_string_literal: true

require_relative 'utils'
require_relative 'validation'

module DonationSystem
  class InputDataValidator
    VALID_TYPES = { oneoff: 'one-off', recurring: 'recurring' }.freeze
    VALID_METHODS = { stripe: 'stripe', paypal: 'paypal' }.freeze

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
      validation << validate_method
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
      :invalid_amount unless data&.amount && utils.number?(data.amount) &&
                             utils.number(data.amount).positive?
    end

    def validate_currency
      :invalid_currency unless data&.currency && utils.currency?(data.currency)
    end

    def validate_token
      :missing_token unless data&.token
    end

    def validate_email
      :missing_email unless data&.email
    end

    def validate_method
      :invalid_donation_method unless data&.method &&
                                      VALID_METHODS.values.include?(data.method)
    end

    def utils
      Utils.new
    end
  end
end
