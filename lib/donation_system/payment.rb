# frozen_string_literal: true

require_relative 'donation_data'
require_relative 'salesforce/database'
require_relative 'payment_gateway'
require_relative 'thank_you_mailer'
require_relative 'selector'

module DonationSystem
  class Payment
    def self.attempt(request_data)
      new(request_data).attempt
    end

    def initialize(request_data)
      @request_data = request_data
    end

    def attempt
      result = PaymentGateway.charge(request_data)
      return result.errors unless result.okay?
      payment_data = adapt_to_salesforce(result)
      ThankYouMailer.send_email(payment_data.email, payment_data.name)
      Salesforce::Database.add_donation(payment_data)
    end

    private

    attr_reader :request_data

    def adapt_to_salesforce(result)
      Selector.select_adapter(request_data).adapt(request_data, result.item)
    end
  end
end
