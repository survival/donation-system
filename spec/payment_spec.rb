# frozen_string_literal: true

require 'payment'

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
  end
end
