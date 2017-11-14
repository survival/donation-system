# frozen_string_literal: true

require_relative 'salesforce/database'
require_relative 'stripe_wrapper/gateway'
require_relative 'thank_you_mailer'

module DonationSystem
  class Payment
    def self.attempt(request_data)
      new(request_data).attempt
    end

    def initialize(request_data)
      @request_data = request_data
    end

    def attempt
      result = StripeWrapper::Gateway.charge(request_data)
      if result.okay?
        ThankYouMailer.send_email(request_data.email, request_data.name)
        Salesforce::Database.add_donation(request_data)
      else
        result.errors
      end
    end

    private

    attr_reader :request_data
  end
end
