# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/fields_generator'
require 'spec_helper'

module DonationSystem
  module StripeWrapper
    RSpec.describe FieldsGenerator do
      let(:generator) { described_class.new(VALID_REQUEST_DATA) }

      before { allow(Random).to receive(:rand).and_return(0) }

      describe 'fields for Charge' do
        let(:fields) { generator.for_charge }

        it 'has required field amount' do
          expect(fields[:amount]).to eq(1234)
        end

        it 'has required field currency' do
          expect(fields[:currency]).to eq('gbp')
        end

        it 'has required field Stripe token' do
          expect(fields[:source]).to eq('tok_visa')
        end

        it 'has optional field description with the donor email' do
          expect(fields[:description]).to include('user@example.com')
        end

        it 'has optional field metadata with payment number' do
          expect(fields[:metadata][:number]).to eq('P000000000')
        end
      end

      describe 'fields for Plan' do
        let(:fields) { generator.for_plan }

        it 'has required field name' do
          expect(fields[:name]).to eq('Mandate MC000000000')
        end

        it 'has required field amount' do
          expect(fields[:amount]).to eq(1234)
        end

        it 'has required field currency' do
          expect(fields[:currency]).to eq('gbp')
        end

        it 'has required field interval' do
          expect(fields[:interval]).to eq('month')
        end

        it 'has optional field id' do
          expect(fields[:id]).to eq('mandate_MC000000000')
        end

        it 'has optional field interval_count' do
          expect(fields[:interval_count]).to eq(1)
        end
      end

      describe 'fields for Customer' do
        let(:fields) { generator.for_customer }

        it 'has optional field email' do
          expect(fields[:email]).to eq('user@example.com')
        end

        it 'has optional field source' do
          expect(fields[:source]).to eq('tok_visa')
        end

        it 'has optional field description' do
          expect(fields[:description]).to eq('Customer for user@example.com')
        end
      end

      describe 'fields for Subscription' do
        let(:fields) do
          generator.for_subscription(
            StripePlanFake.new('mandate_MC000000000'),
            StripeCustomerFake.new('cus_0123456')
          )
        end

        it 'has required field customer' do
          expect(fields[:customer]).to eq('cus_0123456')
        end

        it 'has required field plan' do
          expect(fields[:items].first[:plan]).to eq('mandate_MC000000000')
        end

        it 'has optional field metadata' do
          metadata = fields[:metadata]
          expect(metadata[:description]).to include('user@example.com')
          expect(metadata[:description]).to include('mandate_MC000000000')
          expect(metadata[:mandate]).to eq('mandate_MC000000000')
          expect(metadata[:number]).to eq('MC000000000')
          expect(metadata[:brand]).to eq('Visa')
        end
      end
    end
  end
end
