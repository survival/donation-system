# frozen_string_literal: true

require 'spec_helper'
require 'payment'

RSpec.describe Payment do
  Request = Struct.new(:name)

  let(:request) { Request.new('bob') }
  let(:payment) { Payment.new(request) }

  it 'stores the request object passed in the initializer' do
    expect(payment.request).to eq request
  end

  describe '#attempt' do
    it 'is successful' do
      WebMock.stub_request(:post, 'https://api.stripe.com/v1/charges')
             .to_return(status: 200, headers: {})
      expect(payment.attempt).to be(true)
    end

    it 'is failure' do
      WebMock.stub_request(:post, 'https://api.stripe.com/v1/charges')
             .to_return(status: 500, headers: {})
      expect(payment.attempt).to be(false)
    end
  end
end
