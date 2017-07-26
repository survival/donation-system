# frozen_string_literal: true

require 'net/http'
require 'net/https'

class Payment
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def attempt
    response = post('https://api.stripe.com/v1/charges')
    if response.code == '200'
      []
    elsif response.code == '402'
      [:card_error]
    else
      [:invalid_request]
    end
  end

  private

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
end
