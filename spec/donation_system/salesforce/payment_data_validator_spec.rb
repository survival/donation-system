# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/salesforce/payment_data_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe PaymentDataValidator do
      let(:data) { VALID_ONEOFF_PAYMENT_DATA.dup }
      let(:result) { validate(data) }

      it 'has no validation errors if data is valid' do
        expect(result).to be_okay
      end

      it 'handles null data' do
        result = validate(nil)
        expect(result.errors).to include(:missing_data)
      end

      it 'handles missing last name' do
        data.name = nil
        result = validate(data)
        expect(result.errors).to include(:invalid_last_name)
      end

      it 'handles missing email' do
        data.email = nil
        result = validate(data)
        expect(result.errors).to include(:invalid_email)
      end

      it 'handles missing amount' do
        data.amount = nil
        result = validate(data)
        expect(result.errors).to include(:invalid_amount)
      end

      it 'handles invalid amount' do
        data.amount = 'adsf'
        result = validate(data)
        expect(result.errors).to include(:invalid_amount)
      end

      it 'handles missing creation date' do
        data.created = nil
        result = validate(data)
        expect(result.errors).to include(:invalid_creation_date)
      end

      it 'handles invalid creation date' do
        data.created = 'asdf'
        result = validate(data)
        expect(result.errors).to include(:invalid_creation_date)
      end

      def validate(data)
        described_class.execute(data)
      end
    end
  end
end
