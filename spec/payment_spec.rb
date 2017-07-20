# frozen_string_literal: true

require 'support/with_env'
require 'spec_helper'
require 'payment'

RSpec.describe Payment do
  include Support::WithEnv

  Request = Struct.new(:name)

  let(:request) { Request.new('bob') }
  let(:payment) { Payment.new(request) }

  it 'stores the request object passed in the initializer' do
    expect(payment.request).to eq request
  end

  describe '#attempt', vcr: { record: :once } do
    xit 'is successful' do
      expect(payment.attempt).to be(true)
    end

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
  end
end
