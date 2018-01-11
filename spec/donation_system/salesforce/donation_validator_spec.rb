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
      let(:supporter) { SupporterFake.new('1') }
      let(:result) { validate(data, supporter) }
      let(:fields) { result.item }

      describe 'Salesforce required fields' do
        it 'has required field amount' do
          expect(fields[:Amount]).to eq('12.34')
        end

        it 'has required field closed date' do
          expect(fields[:CloseDate]).to eq('2017-11-17')
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

      describe 'optional fields' do
        it 'can have a currency' do
          expect(fields[:CurrencyIsoCode]).to eq('GBP')
        end

        it 'can have the last 4 digits of the card' do
          expect(fields[:Last_digits__c]).to eq('4242')
        end

        it 'can have a card brand number' do
          expect(fields[:Card_type__c]).to eq('Visa')
        end

        it 'can have a transaction id' do
          expect(fields[:Gateway_transaction_ID__c])
            .to eq('ch_1BPDARGjXKYZTzxWrD35FFDc')
        end

        it 'can have a receiving organisation' do
          expect(fields[:Receiving_Organization__c]).to eq('Survival UK')
        end

        it 'can have a payment method' do
          expect(fields[:Payment_method__c]).to eq('Card (Stripe)')
        end

        it 'can have a record type id' do
          expect(fields[:RecordTypeId]).to eq('01280000000Fvqi')
        end

        it 'can have a private field' do
          expect(fields[:IsPrivate]).to eq(false)
        end

        it 'can have a gift aid information' do
          expect(fields[:Gift_Aid__c]).to eq(true)
          expect(fields[:Block_Gift_Aid_Reclaim__c]).to eq(false)
        end

        it 'can have a fundraising field' do
          expect(fields[:Fundraising__c]).to eq(false)
        end
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
