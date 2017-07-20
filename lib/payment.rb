# frozen_string_literal: true

require 'net/http'
require 'net/https'

class Payment
  attr_accessor :request

  def initialize(request)
    @request = request
  end

  def attempt
    post('https://api.stripe.com/v1/charges')
    [:invalid_request]
  end

  private

  def post(url)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request.basic_auth(ENV['STRIPE_API_KEY'], '')
    https.request(request)
  end
end
