# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/fields_generator'
require 'donation_system/stripe_wrapper/resource_creator'
require 'donation_system/stripe_wrapper/resource_creator_shared_examples'

require 'spec_helper'
require 'support/with_env'

module DonationSystem
  module StripeWrapper
    RSpec.describe ResourceCreator do
      describe 'Stripe Charge creator' do
        let(:resource) { Stripe::Charge }
        let(:fields) { FieldsGenerator.new(VALID_REQUEST_DATA).for_charge.dup }
        let(:stripe_endpoint) { 'https://api.stripe.com/v1/charges' }

        it_behaves_like 'Stripe resource creator', Stripe::Charge

        describe 'when missing or invalid parameters', vcr: { record: :once } do
          it 'fails' do
            expect_creation_to_fail_with(:invalid_parameter, {})
          end

          it 'fails with missing amount' do
            fields[:amount] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing currency' do
            fields[:currency] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing token' do
            fields[:source] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with invalid card number' do
            fields[:source] = 'tok_chargeDeclined'
            expect_creation_to_fail_with(:declined_card, fields)
          end

          it 'fails with a valid API key and expired card' do
            fields[:source] = 'tok_chargeDeclinedExpiredCard'
            expect_creation_to_fail_with(:declined_card, fields)
          end
        end
      end

      describe 'Stripe Plan creator' do
        let(:resource) { Stripe::Plan }
        let(:fields) { FieldsGenerator.new(VALID_REQUEST_DATA).for_plan.dup }
        let(:stripe_endpoint) { 'https://api.stripe.com/v1/plans' }

        it_behaves_like 'Stripe resource creator', Stripe::Plan

        describe 'when missing or invalid parameters', vcr: { record: :once } do
          it 'fails' do
            expect_creation_to_fail_with(:invalid_parameter, {})
          end

          it 'fails with missing name' do
            fields[:name] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing amount' do
            fields[:amount] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing currency' do
            fields[:currency] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing interval' do
            fields[:interval] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with unknown parameters' do
            fields[:foo] = 'foo'
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end
        end
      end

      describe 'Stripe Customer creator' do
        let(:resource) { Stripe::Customer }
        let(:fields) { FieldsGenerator.new(VALID_REQUEST_DATA).for_customer.dup }
        let(:stripe_endpoint) { 'https://api.stripe.com/v1/customers' }

        it_behaves_like 'Stripe resource creator', Stripe::Customer

        describe 'when missing or invalid parameters', vcr: { record: :once } do
          it 'does not fail with empty fields' do
            result = described_class.create(resource, {})
            expect(result).to be_okay
          end

          it 'fails with unknown parameters' do
            fields[:foo] = 'foo'
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end
        end
      end

      describe 'Stripe Subscription creator' do
        let(:resource) { Stripe::Subscription }
        let(:fields) do
          FieldsGenerator.new(VALID_REQUEST_DATA).for_subscription(
            StripePlanFake.new('mandate_MC362421552'),
            StripeCustomerFake.new('cus_CAISMYrOdzMtdE')
          ).dup
        end
        let(:stripe_endpoint) { 'https://api.stripe.com/v1/subscriptions' }

        it_behaves_like 'Stripe resource creator', Stripe::Subscription

        describe 'when missing or invalid parameters', vcr: { record: :once } do
          it 'fails' do
            expect_creation_to_fail_with(:invalid_parameter, {})
          end

          it 'fails with missing plan' do
            fields[:items] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with missing customer' do
            fields[:customer] = nil
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails if plan not found' do
            fields[:items] = [{ plan: 'i-dont-exist' }]
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails if customer not found' do
            fields[:customer] = 'i-dont-exist'
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end

          it 'fails with unknown parameters' do
            fields[:foo] = 'foo'
            expect_creation_to_fail_with(:invalid_parameter, fields)
          end
        end
      end

      def expect_creation_to_fail_with(error_code, custom_fields = nil)
        result = described_class.create(resource, custom_fields || fields)
        expect(result.item).to be_nil
        expect(result.errors).to eq([error_code])
      end
    end
  end
end
