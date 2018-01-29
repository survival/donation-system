# frozen_string_literal: true

require_relative 'input_data_validator'
require_relative 'result'
require_relative 'selector'

module DonationSystem
  class PaymentGateway
    def self.charge(data)
      new(data).charge
    end

    def initialize(data)
      @data = data
    end

    def charge
      return failed_validation unless validation.okay?
      selected_gateway.charge(data)
    end

    private

    attr_reader :data

    def failed_validation
      Result.new(nil, validation.errors)
    end

    def selected_gateway
      Selector.select_gateway(data)
    end

    def validation
      @validation ||= InputDataValidator.execute(data)
    end
  end
end
