# frozen_string_literal: true

require 'net/http'
require 'net/https'
require 'salesforce/database'
require 'thank_you_mailer'

class Payment
  attr_accessor :request

  def initialize(request, supporter_database = Salesforce::Database)
    @request = request
    @supporter_database = supporter_database
  end

  def attempt
    response = post('https://api.stripe.com/v1/charges')
    errors = stripe_error_codes.fetch(response.code, [:invalid_request])
    if errors.empty?
      ThankYouMailer.send_email(request.email, request.name)
      supporter_database.add_donation(request)
    end
    errors
  end

  private

  attr_reader :supporter_database

  def post(url)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    http_request = Net::HTTP::Post.new(uri.path)
    http_request.basic_auth(ENV['STRIPE_API_KEY'], '')
    http_request.set_form_data(form_data)
    https.request(http_request)
  end

  def form_data
    {
      'amount' => request.amount,
      'currency' => request.currency,
      'source[object]' => 'card',
      'source[number]' => request.card_number,
      'source[exp_month]' => request.exp_month,
      'source[exp_year]' => request.exp_year,
      'source[cvc]' => request.cvc
    }
  end

  def stripe_error_codes
    {
      '200' => [],
      '402' => [:card_error]
    }
  end
end
