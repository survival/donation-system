# frozen_string_literal: true

require 'payment'
require 'gateway'

describe Payment do
  Request = Struct.new(:name)

  let(:request) { Request.new('bob') }
  let(:payment) { Payment.new(request) }

  it 'stores the request object passed in the initializer' do
    expect(payment.request).to eq request
  end

  describe '#attempt' do
    it 'returns a response object' do
      response = payment.attempt
      expect(response.request).to eq request
    end

    it 'calls process on the gateway' do
      expect_any_instance_of(Gateway).to receive(:process).with(request)

      payment.attempt
    end
  end
end
