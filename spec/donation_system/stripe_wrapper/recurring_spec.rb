# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/recurring'

require 'spec_helper'
require 'support/with_env'

module DonationSystem
  module StripeWrapper
    RSpec.describe Recurring do
      let(:data) { VALID_REQUEST_DATA.dup }
      let(:plan) { Result.new(StripePlanFake.new('plan_id'), []) }
      let(:customer) { Result.new(StripeCustomerFake.new('customer_id'), []) }

      before do
        allow(ResourceCreator).to receive(:create)
          .with(Stripe::Plan, anything).and_return(plan)
        allow(ResourceCreator).to receive(:create)
          .with(Stripe::Customer, anything).and_return(customer)
        allow(ResourceCreator).to receive(:create)
          .with(Stripe::Subscription, anything).and_return(Result.new('', []))
      end

      describe 'when successful' do
        it 'has no errors' do
          expect(described_class.charge(data)).to be_okay
        end

        it 'creates a plan' do
          expect(ResourceCreator).to receive(:create)
            .with(Stripe::Plan, anything)
          described_class.charge(data)
        end

        it 'creates a customer' do
          expect(ResourceCreator).to receive(:create)
            .with(Stripe::Customer, anything)
          described_class.charge(data)
        end

        it 'creates a subscription' do
          expect(ResourceCreator).to receive(:create)
            .with(Stripe::Subscription, anything)
          described_class.charge(data)
        end

        it 'passes the plan and customer to the subscription' do
          fields = {
            customer: 'customer_id', items: [{ plan: 'plan_id' }],
            metadata: anything
          }
          expect(ResourceCreator).to receive(:create)
            .with(Stripe::Subscription, fields)
          described_class.charge(data)
        end
      end

      describe 'when unsuccessful' do
        let(:bad_result) { Result.new(nil, [:error]) }

        it 'has errors if plan creation fails' do
          allow(ResourceCreator).to receive(:create)
            .with(Stripe::Plan, anything)
            .and_return(bad_result)
          result = described_class.charge(data)

          expect(result).not_to be_okay
          expect(result.errors).to eq([:error])
        end

        it 'has errors if customer creation fails' do
          allow(ResourceCreator).to receive(:create)
            .with(Stripe::Customer, anything)
            .and_return(bad_result)
          result = described_class.charge(data)

          expect(result).not_to be_okay
          expect(result.errors).to eq([:error])
        end

        it 'has errors if subscriptions creation fails' do
          allow(ResourceCreator).to receive(:create)
            .with(Stripe::Subscription, anything)
            .and_return(bad_result)
          result = described_class.charge(data)

          expect(result).not_to be_okay
          expect(result.errors).to eq([:error])
        end
      end
    end
  end
end
