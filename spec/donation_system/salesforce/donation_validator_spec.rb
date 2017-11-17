# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/donation_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe DonationValidator do
      let(:data) { DonationData.new(VALID_REQUEST_DATA, VALID_PAYMENT_DATA) }
      let(:supporter) { SupporterFake.new('1') }
      let(:result) { validate(data, supporter) }
      let(:fields) { result.item }

      describe 'Salesforce required fields' do
        it 'has required field amount' do
          expect(fields[:Amount]).to eq('2000')
        end

        it 'has required field closed date' do
          expect(fields[:CloseDate]).to eq('2017-09-11')
        end

        it 'has required field name' do
          expect(fields[:Name]).to eq('Online donation')
        end

        it 'has required field stage name' do
          expect(fields[:StageName]).to eq('Received')
        end
      end

      describe 'application required fields' do
        it 'has required field account id' do
          expect(fields[:AccountId]).to eq('1')
        end
      end

      describe 'validations' do
        let(:request_data) { VALID_REQUEST_DATA.dup }
        let(:payment_data) { VALID_PAYMENT_DATA.dup }

        it 'has no validation errors if data is valid' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles missing data' do
          result = validate(nil, supporter)
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
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

        it 'handles missing supporter' do
          result = validate(data, nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_account_id)
        end

        it 'handles invalid account id' do
          result = validate(data, SupporterFake.new(nil))
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
