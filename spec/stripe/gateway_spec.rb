# frozen_string_literal: true

require 'spec_helper'
require 'stripe/gateway'
require 'support/with_env'

module Stripe
  RSpec.describe Gateway do
    RawStripeData = Struct.new(:amount, :currency, :token, :email, :name)

    describe 'when unsuccessful', vcr: { record: :once } do
      include Support::WithEnv

      let(:stripe_endpoint) { 'https://api.stripe.com/v1/charges' }
      let(:data) { RawStripeData.new('', '', 'tok_visa', '', '') }

      it 'fails if no data is provided' do
        result = described_class.charge(nil)
        expect(result.item).to be_nil
        expect(result.errors).to include(:missing_data)

        data = RawStripeData.new(nil, nil, nil, nil, nil)
        result = described_class.charge(data)
        expect(result.item).to be_nil
        expect(result.errors).to include(:missing_amount)
      end

      it 'fails without an API key' do
        with_env('STRIPE_SECRET_KEY' => '') do
          expect_charge_to_fail_with(:invalid_api_key)
        end
      end

      it 'fails with an invalid API key' do
        with_env('STRIPE_SECRET_KEY' => 'aaaaa') do
          expect_charge_to_fail_with(:invalid_api_key)
        end
      end

      it 'fails with a valid API key but missing parameters' do
        expect_charge_to_fail_with(:invalid_parameter)
      end

      it 'fails with a valid API key and invalid card number' do
        data = RawStripeData.new(
          '1000', 'usd', 'tok_chargeDeclined', 'user@test.com', 'foo'
        )
        expect_charge_to_fail_with(:declined_card, data)
      end

      it 'fails with a valid API key and expired card' do
        data = RawStripeData.new(
          '1000', 'usd', 'tok_chargeDeclinedExpiredCard', 'user@test.com', 'foo'
        )
        expect_charge_to_fail_with(:declined_card, data)
      end

      it 'fails due to net conflicts' do
        stub_request(:post, stripe_endpoint).to_return(status: 409, body: '')
        expect_charge_to_fail_with(:invalid_response_object)
      end

      it 'fails due to too many requests' do
        allow(Stripe::Charge)
          .to receive(:create)
          .and_raise(Stripe::RateLimitError)
        expect_charge_to_fail_with(:too_many_requests)
      end

      it 'fails due to a Stripe connection error' do
        allow(Stripe::Charge)
          .to receive(:create)
          .and_raise(Stripe::APIConnectionError)
        expect_charge_to_fail_with(:connection_problems)
      end

      it 'fails due to Stripe server errors' do
        allow(Stripe::Charge).to receive(:create).and_raise(Stripe::StripeError)
        expect_charge_to_fail_with(:stripe_error)
      end

      it 'fails due to reasons unrelated to Stripe' do
        allow(Stripe::Charge).to receive(:create).and_raise(StandardError)
        expect_charge_to_fail_with(:unknown_error)
      end
    end

    describe 'when successful', vcr: { record: :once } do
      it 'succeeds with a valid API key and valid parameters' do
        data = RawStripeData.new(
          '1000', 'usd', 'tok_visa', 'user@example.com', 'Name'
        )
        result = described_class.charge(data)
        expect(result.item.status).to eq('succeeded')
        expect(result.errors).to be_empty
      end
    end

    def expect_charge_to_fail_with(error_code, custom_data = nil)
      result = described_class.charge(custom_data || data)
      expect(result.item).to be_nil
      expect(result.errors).to eq([error_code])
    end
  end
end
