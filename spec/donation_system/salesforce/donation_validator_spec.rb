# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/donation_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe DonationValidator do
      let(:data) do
        DonationData.new(VALID_REQUEST_DATA, VALID_ONEOFF_PAYMENT_DATA)
      end
      let(:supporter) { SupporterFake.new('id', '1') }
      let(:result) { validate(data, supporter) }
      let(:fields) { result.item.fields }

      it 'returns fields for one-off if one-off donation' do
        expect(fields[:Web_Payment_Number__c]).not_to be_nil
        expect(result.item.table).to eq(described_class::ONEOFF_TABLE)
      end

      it 'returns fields for recurring if recurring donation' do
        data = DonationData.new(VALID_REQUEST_DATA, VALID_RECURRING_PAYMENT_DATA)
        result = validate(data, supporter)
        expect(result.item.fields[:Web_Mandate_Number__c]).not_to be_nil
        expect(result.item.table).to eq(described_class::RECURRING_TABLE)
      end

      describe 'validations' do
        let(:request_data) { VALID_REQUEST_DATA.dup }
        let(:payment_data) { VALID_ONEOFF_PAYMENT_DATA.dup }

        it 'has no validation errors if data is valid' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles missing data' do
          result = validate(nil, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing request data' do
          result = validate(DonationData.new(nil, payment_data), supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_request_data)
        end

        it 'handles missing payment data' do
          result = validate(DonationData.new(request_data, nil), supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_payment_data)
        end

        it 'handles missing amount' do
          payment_data.amount = nil
          data = DonationData.new(request_data, payment_data)
          result = validate(data, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles invalid amount' do
          payment_data.amount = 'adsf'
          data = DonationData.new(request_data, payment_data)
          result = validate(data, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles missing creation date' do
          payment_data.created = nil
          data = DonationData.new(request_data, payment_data)
          result = validate(data, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_creation_date)
        end

        it 'handles invalid creation date' do
          payment_data.created = 'asdf'
          data = DonationData.new(request_data, payment_data)
          result = validate(data, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_creation_date)
        end

        it 'handles missing supporter' do
          result = validate(data, nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_account_id)
        end

        it 'handles invalid account id' do
          result = validate(data, SupporterFake.new('id', nil))
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_account_id)
        end
      end

      def validate(data, supporter)
        described_class.execute(data, supporter)
      end
    end
  end
end
