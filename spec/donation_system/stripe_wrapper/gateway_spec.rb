# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/gateway'
require 'spec_helper'
require 'support/with_env'

module DonationSystem
  module StripeWrapper
    RSpec.describe Gateway do
      let(:data) { VALID_REQUEST_DATA.dup }

      describe 'when successful', vcr: { record: :once } do
        it 'succeeds with a valid API key and valid parameters' do
          result = described_class.charge(data)
          expect(result.item.status).to eq('succeeded')
          expect(result.errors).to be_empty
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        include Support::WithEnv

        let(:stripe_endpoint) { 'https://api.stripe.com/v1/charges' }

        it 'fails if no data is provided' do
          result = described_class.charge(nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)

          data = RawRequestData.new
          result = described_class.charge(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
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
          data = RawRequestData.new(
            '1000', 'brl', '', '', '', '', '', '', '', '', ''
          )
          result = described_class.charge(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_parameter)
        end

        it 'fails with a valid API key and invalid card number' do
          data.token = 'tok_chargeDeclined'
          expect_charge_to_fail_with(:declined_card, data)
        end

        it 'fails with a valid API key and expired card' do
          data.token = 'tok_chargeDeclinedExpiredCard'
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

      def expect_charge_to_fail_with(error_code, custom_data = nil)
        result = described_class.charge(custom_data || data)
        expect(result.item).to be_nil
        expect(result.errors).to eq([error_code])
      end
    end
  end
end
