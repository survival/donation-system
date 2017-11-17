# frozen_string_literal: true

require_relative 'donation_data'
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
      return result.errors unless result.okay?
      ThankYouMailer.send_email(request_data.email, request_data.name)
      Salesforce::Database.add_donation(
        DonationData.new(request_data, result.item)
      )
    end

    private

    attr_reader :request_data
  end
end
