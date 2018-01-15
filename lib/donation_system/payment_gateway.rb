# frozen_string_literal: true

require_relative 'adapters/stripe_one_off_salesforce'
require_relative 'adapters/stripe_recurring_salesforce'
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
      return one_off_donation if oneoff_donation?
      recurring_donation
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

    def one_off_donation
      result = StripeWrapper::OneOff.charge(data)
      item = Adapters::StripeOneOffSalesforce.adapt(result.item) if result.okay?
      Result.new(item, result.errors)
    end

    def recurring_donation
      result = StripeWrapper::Recurring.charge(data)
      item = Adapters::StripeRecurringSalesforce.adapt(result.item) if result.okay?
      Result.new(item, result.errors)
    end
  end
end
