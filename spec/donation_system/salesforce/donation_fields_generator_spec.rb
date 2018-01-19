# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/donation_fields_generator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.shared_examples 'Generic fields' do
      describe 'optional fields' do
        it 'can have a currency' do
          expect(fields[:CurrencyIsoCode]).to eq('GBP')
        end

        it 'can have the last 4 digits of the card' do
          expect(fields[:Last_digits__c]).to eq('4242')
        end

        it 'can have a card brand' do
          expect(fields[:Card_type__c]).to eq('Visa')
        end

        it 'can have a receiving organisation' do
          expect(fields[:Receiving_Organization__c])
            .to eq(described_class::SURVIVAL_UK)
        end

        it 'can have a payment method' do
          expect(fields[:Payment_method__c]).to eq('Card (Stripe)')
        end
      end
    end

    RSpec.describe DonationFieldsGenerator do
      let(:supporter) { SupporterFake.new('id', '1') }

      describe '#for_oneoff' do
        let(:fields) do
          described_class.new(
            VALID_REQUEST_DATA, VALID_ONEOFF_PAYMENT_DATA, supporter
          ).for_oneoff
        end

        it_behaves_like 'Generic fields'

        describe 'Salesforce required fields' do
          it 'has required field amount' do
            expect(fields[:Amount]).to eq('12.34')
          end

          it 'has required field closed date' do
            expect(fields[:CloseDate]).to eq('2017-11-17')
          end

          it 'has required field name' do
            expect(fields[:Name]).to eq(described_class::NAME)
          end

          it 'has required field stage name' do
            expect(fields[:StageName]).to eq(described_class::RECEIVED)
          end
        end

        describe 'application required fields' do
          it 'has required field account id' do
            expect(fields[:AccountId]).to eq('1')
          end
        end

        describe 'optional fields' do
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

          it 'can have a transaction id' do
            expect(fields[:Gateway_transaction_ID__c])
              .to eq('ch_1BPDARGjXKYZTzxWrD35FFDc')
          end

          it 'can have a payment number' do
            expect(fields[:Web_Payment_Number__c]).to eq('P123456789')
          end
        end
      end

      describe '#for_recurring' do
        let(:fields) do
          described_class.new(
            VALID_REQUEST_DATA, VALID_RECURRING_PAYMENT_DATA, supporter
          ).for_recurring
        end

        it_behaves_like 'Generic fields'

        describe 'Salesforce required fields' do
          it 'has required field Contact__c' do
            expect(fields[:Contact__c]).to eq('id')
          end

          it 'has required field Amount__c' do
            expect(fields[:Amount__c]).to eq('12.34')
          end
        end

        describe 'optional fields' do
          it 'can have a record type id' do
            expect(fields[:RecordTypeId]).to eq('01280000000Fvsz')
          end

          it 'can have expiry month' do
            expect(fields[:Card_Expiry_Month__c]).to eq(8)
          end

          it 'can have expiry year' do
            expect(fields[:Card_Expiry_Year__c]).to eq(2100)
          end

          it 'can have a mandate id' do
            expect(fields[:Gateway_mandate_ID__c])
              .to eq('sub_C6wrGA60bGiHfV')
          end

          it 'can have a mandate number' do
            expect(fields[:Web_Mandate_Number__c]).to eq('MC123456789')
          end

          it 'can have a start date' do
            expect(fields[:Start_Date__c]).to eq('2017-11-17')
          end

          it 'can have a mandate reference' do
            expect(fields[:DD_Mandate_Reference__c]).to be_nil
          end

          it 'can have a collection day' do
            expect(fields[:Collection_day__c]).to be_nil
          end

          it 'can have a mandate method' do
            expect(fields[:DD_Method__c]).to be_nil
          end

          it 'can have an account holder name' do
            expect(fields[:Account_Holder_Name__c]).to be_nil
          end
        end
      end
    end
  end
end
