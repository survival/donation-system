# frozen_string_literal: true

require 'salesforce/database'
require 'stripe/gateway'
require 'thank_you_mailer'

class Payment
  def initialize(request_data, supporter_database = Salesforce::Database)
    @request_data = request_data
    @supporter_database = supporter_database
  end

  def attempt
    result = Stripe::Gateway.charge(request_data)
    if result.okay?
      ThankYouMailer.send_email(request_data.email, request_data.name)
      supporter_database.add_donation(request_data)
    else
      result.errors
    end
  end

  private

  attr_reader :request_data, :supporter_database
end
