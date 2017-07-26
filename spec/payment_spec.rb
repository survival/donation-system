# frozen_string_literal: true

require 'support/with_env'
require 'spec_helper'
require 'payment'

RSpec.describe Payment do
  include Support::WithEnv

  Request = Struct.new(
    :amount, :currency, :card_number, :cvc, :exp_year, :exp_month
  )

  let(:request) { Request.new(nil) }
  let(:payment) { Payment.new(request) }

  it 'stores the request object passed in the initializer' do
    expect(payment.request).to eq request
  end

  describe '#attempt', vcr: { record: :once } do
    it 'fails without an api key' do
      with_env('STRIPE_API_KEY' => '') do
        expect(payment.attempt).to eq([:invalid_request])
      end
    end

    it 'fails with an invalid api key' do
      with_env('STRIPE_API_KEY' => 'aaaaa') do
        expect(payment.attempt).to eq([:invalid_request])
      end
    end

    it 'fails with a valid api key but no other parameters' do
      expect(payment.attempt).to eq([:invalid_request])
    end

    it 'succeeds with a valid api key and valid parameters' do
      request = Request.new(
        '1000', 'usd', '4242424242424242', '123', '2020', '01'
      )
      payment = Payment.new(request)
      expect(payment.attempt).to eq([])
    end
  end
end
