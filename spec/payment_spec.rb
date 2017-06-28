# frozen_string_literal: true

require 'payment'

describe Payment do
  Request = Struct.new(:name)

  it 'stores the request object passed in the initializer' do
    request = Request.new('bob')
    payment = Payment.new(request)

    expect(payment.request).to eq request
  end

  describe '#process' do
    it 'returns a response object' do
      request = Request.new('bob')
      payment = Payment.new(request)

      response = payment.process
      expect(response.request).to eq request
    end
  end
end
