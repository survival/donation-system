# frozen_string_literal: true

require 'salesforce/database'
require 'stripe/gateway'
require 'thank_you_mailer'

class Payment
  def self.attempt(request_data)
    new(request_data).attempt
  end

  def initialize(request_data)
    @request_data = request_data
  end

  def attempt
    result = Stripe::Gateway.charge(request_data)
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
