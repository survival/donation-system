# frozen_string_literal: true

require_relative 'input_data_validator'
require_relative 'result'
require_relative 'stripe_wrapper/one_off'
require_relative 'stripe_wrapper/recurring'

module DonationSystem
  class PaymentGateway
    def self.charge(data)
      new(data).charge
    end

    def initialize(data)
      @data = data
    end

    def charge
      return validation_result unless validation.okay?
      return StripeWrapper::OneOff.charge(data) if oneoff_donation?
      StripeWrapper::Recurring.charge(data)
    end

    private

    attr_reader :data

    def validation
      @validation ||= InputDataValidator.execute(data)
    end

    def validation_result
      Result.new(nil, validation.errors)
    end

    def oneoff_donation?
      data.type == InputDataValidator::VALID_TYPES[:oneoff]
    end
  end
end
