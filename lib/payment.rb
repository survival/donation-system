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
    response.code == '200'
  end

  private

  def post(url)
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    https.request(request)
  end
end
