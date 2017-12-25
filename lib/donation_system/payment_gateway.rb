# frozen_string_literal: true

require_relative 'stripe_wrapper/gateway'

module DonationSystem
  class PaymentGateway
    def self.charge(data)
      new(data).charge
    end

    def initialize(data)
      @data = data
    end

    def charge
      StripeWrapper::Gateway.charge(data)
    end

    private

    attr_reader :data
  end
end
