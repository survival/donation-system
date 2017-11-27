# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/salesforce/donation_validator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe DonationValidator do
      let(:result) { validate_values(amount: '2000', account_id: '1') }
      let(:fields) { result.item }

      describe 'Salesforce required fields' do
        it 'requires an amount' do
          expect(fields[:Amount]).to eq('2000')
        end

        it 'requires a closed date' do
          expect(fields[:CloseDate]).to eq('2017-09-11')
        end

        it 'requires a name' do
          expect(fields[:Name]).to eq('Online donation')
        end

        it 'requires a stage name' do
          expect(fields[:StageName]).to eq('Received')
        end
      end

      describe 'application required fields' do
        it 'requires an account id' do
          expect(fields[:AccountId]).to eq('1')
        end
      end

      describe 'validations' do
        it 'has no validation errors if data is valid' do
          expect(result).to be_okay
          expect(fields).not_to be_nil
        end

        it 'handles missing data' do
          result = validate(nil, SupporterFake.new('1'))
          expect(result.item).to be_nil
          expect(result.errors).to include(:missing_data)
        end

        it 'handles missing amount' do
          result = validate_values(amount: nil, account_id: '1')
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles invalid amount' do
          result = validate_values(amount: 'asdf', account_id: '1')
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_amount)
        end

        it 'handles missing supporter' do
          result = validate(RawDonationData.new('1'), nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_account_id)
        end

        it 'handles invalid account id' do
          result = validate_values(amount: '2000', account_id: nil)
          expect(result.item).to be_nil
          expect(result.errors).to include(:invalid_account_id)
        end
      end

      def validate(data, supporter)
        described_class.execute(data, supporter)
      end

      def validate_values(values)
        data = RawDonationData.new(values[:amount])
        supporter = SupporterFake.new(values[:account_id])
        described_class.execute(data, supporter)
      end
    end
  end
end
