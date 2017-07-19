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

  describe '#attempt', vcr: { record: :once } do
    xit 'is successful' do
      expect(payment.attempt).to be(true)
    end

    it 'fails without an api key' do
      expect(payment.attempt).to eq([:no_api_key])
    end
  end
end
