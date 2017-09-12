# frozen_string_literal: true

require 'payment'
require 'salesforce/database'
require 'spec_helper'
require 'support/with_env'
require 'thank_you_mailer'

RSpec.describe Payment do
  include Support::WithEnv

  Request = Struct.new(
    :amount, :currency, :card_number, :cvc, :exp_year, :exp_month, :email, :name
  )

  let(:request) { Request.new(nil) }
  let(:payment) { described_class.new(request) }

  before { allow(Salesforce::Database).to receive(:add_donation) }

  it 'stores the request object passed in the initializer' do
    expect(payment.request).to eq(request)
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

    it 'fails with a valid api key and invalid card number' do
      request = Request.new(
        '1000', 'usd', '1235424242424242', '123', '2020', '01',
        'irrelevant', 'irrelevant'
      )
      payment = described_class.new(request)
      expect(payment.attempt).to eq([:card_error])
    end

    context 'success' do
      let(:request) do
        Request.new(
          '1000', 'usd', '4242424242424242', '123', '2020', '01',
          'user@example.com', 'Name'
        )
      end

      it 'succeeds with a valid api key and valid parameters' do
        payment = described_class.new(request)
        expect(payment.attempt).to be_empty
      end

      it 'should send a thank you email' do
        allow(ThankYouMailer).to receive(:send_email)
        described_class.new(request).attempt
        expect(ThankYouMailer).to have_received(:send_email)
          .with('user@example.com', 'Name')
      end

      it 'adds the donation to the supporters database' do
        described_class.new(request).attempt
        expect(Salesforce::Database).to have_received(:add_donation)
          .with(request)
      end
    end
  end
end
