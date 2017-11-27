# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/supporter_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe SupporterValidator do
      let(:data) { DonationData.new(VALID_REQUEST_DATA, VALID_PAYMENT_DATA) }
      let(:result) { validate(data) }
      let(:fields) { result.item }

      describe 'Salesforce required fields' do
        it 'requires a last name' do
          expect(fields[:LastName]).to eq('Firstname Lastname')
        end
      end

      describe 'application required fields' do
        it 'requires an email' do
          expect(fields[:Email]).to eq('user@example.com')
        end
      end

      describe 'validations' do
        let(:request_data) { VALID_REQUEST_DATA.dup }

        it 'has no validation errors if data is valid' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles null data' do
          result = validate(nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing last name' do
          request_data.name = nil
          result = validate(DonationData.new(request_data, VALID_PAYMENT_DATA))
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_last_name)
        end

        it 'handles missing email' do
          request_data.email = nil
          result = validate(DonationData.new(request_data, VALID_PAYMENT_DATA))
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_email)
        end
      end

      def validate(data)
        described_class.execute(data)
      end
    end
  end
end
