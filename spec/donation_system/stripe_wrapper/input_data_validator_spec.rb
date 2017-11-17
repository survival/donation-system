# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/stripe_wrapper/input_data_validator'
require 'spec_helper'

module DonationSystem
  module StripeWrapper
    RSpec.describe InputDataValidator do
      describe 'Stripe required fields' do
        let(:result) { validate(VALID_REQUEST_DATA) }
        let(:fields) { result.item }

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
      end

      describe 'validations' do
        let(:data) { VALID_REQUEST_DATA.dup }

        it 'has no validation errors if data is present' do
          result = validate(data)
          expect(result).to be_okay
          expect(result.item).not_to be_nil
        end

        it 'handles null data' do
          result = validate(nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing amount' do
          data.amount = nil
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles invalid amount' do
          data.amount = 'asdf'
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles valid but negative amount' do
          data.amount = '-12.34567'
          result = validate(data)
          expect(result.item[:amount]).to eq(1235)
        end

        it 'handles missing currency' do
          data.currency = nil
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_currency)
        end

        it 'handles invalid currency' do
          data.currency = ''
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_currency)
        end

        it 'handles unsupported currency' do
          data.currency = 'unsupported'
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_currency)
        end

        it 'handles missing token' do
          data.token = nil
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_token)
        end

        it 'handles missing email' do
          data.email = nil
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_email)
        end
      end

      def validate(data)
        described_class.execute(data)
      end
    end
  end
end
