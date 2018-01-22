# frozen_string_literal: true

require 'spec_helper'
require 'support/with_env'

module DonationSystem
  module StripeWrapper
    RSpec.shared_examples 'Stripe resource creator' do |resource|
      describe 'when successful', vcr: { record: :once } do
        it 'succeeds with a valid API key and valid parameters' do
          result = described_class.create(resource, fields)
          expect(result).to be_okay
        end
      end

      describe 'when API key problems', vcr: { record: :once } do
        include Support::WithEnv

        it 'fails without an API key' do
          with_env('STRIPE_SECRET_KEY' => '') do
            expect_creation_to_fail_with(:invalid_api_key)
          end
        end

        it 'fails with an invalid API key' do
          with_env('STRIPE_SECRET_KEY' => 'aaaaa') do
            expect_creation_to_fail_with(:invalid_api_key)
          end
        end
      end

      describe 'when net errors' do
        it 'fails due to net conflicts' do
          stub_request(:post, stripe_endpoint).to_return(status: 409, body: '')
          expect_creation_to_fail_with(:invalid_response_object)
        end

        it 'fails due to too many requests' do
          allow(resource)
            .to receive(:create)
            .with(any_args)
            .and_raise(Stripe::RateLimitError)
          expect_creation_to_fail_with(:too_many_requests)
        end

        it 'fails due to a Stripe connection error' do
          allow(resource)
            .to receive(:create)
            .with(any_args)
            .and_raise(Stripe::APIConnectionError)
          expect_creation_to_fail_with(:connection_problems)
        end

        it 'fails due to Stripe server errors' do
          allow(resource)
            .to receive(:create)
            .with(any_args)
            .and_raise(Stripe::StripeError)
          expect_creation_to_fail_with(:stripe_error)
        end

        it 'fails due to reasons unrelated to Stripe' do
          allow(resource)
            .to receive(:create)
            .with(any_args)
            .and_raise(StandardError)
          expect_creation_to_fail_with(:unknown_error)
        end
      end
    end
  end
end
