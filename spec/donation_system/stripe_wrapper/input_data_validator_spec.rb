# frozen_string_literal: true

require 'donation_system/stripe_wrapper/input_data_validator'
require 'spec_helper'

module DonationSystem
  module StripeWrapper
    RSpec.describe InputDataValidator do
      RawInputData = Struct.new(:amount, :currency, :token, :email, :name)

      let(:data) do
        RawInputData.new(
          '10.50', 'usd', 'stripe_token', 'user@example.com', 'Name'
        )
      end
      let(:result) { validate(data) }
      let(:fields) { result.item }

      describe 'Stripe required fields' do
        it 'has required field amount' do
          expect(fields[:amount]).to eq(1050)
        end

        it 'has required field currency' do
          expect(fields[:currency]).to eq('usd')
        end

        it 'has required field Stripe token' do
          expect(fields[:source]).to eq('stripe_token')
        end

        it 'has optional field description with the donor email' do
          expect(fields[:description]).to include('user@example.com')
        end
      end

      describe 'validations' do
        it 'has no validation errors if data is present' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles null data' do
          result = validate(nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing amount' do
          data = RawInputData.new(
            nil, 'usd', 'stripe_token', 'user@example.com', 'Name'
          )
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
          data = RawInputData.new(
            '1000', nil, 'stripe_token', 'user@example.com', 'Name'
          )
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_currency)
        end

        it 'handles missing token' do
          data = RawInputData.new(
            '1000', 'usd', nil, 'user@example.com', 'Name'
          )
          result = validate(data)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_token)
        end

        it 'handles missing email' do
          data = RawInputData.new(
            '1000', 'usd', 'stripe_token', nil, 'Name'
          )
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
