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
        it 'has required field email' do
          expect(fields[:Email]).to eq('user@example.com')
        end

        it 'has required field first entered' do
          allow(Date).to receive(:today).and_return(Date.new(1000, 1, 1))
          expect(fields[:First_entered__c].year).to eq(1000)
        end
      end

      describe 'optional fields' do
        it 'can have an address' do
          expect(fields[:MailingStreet]).to eq('Address')
        end

        it 'can have a city' do
          expect(fields[:MailingCity]).to eq('City')
        end

        it 'can have a state' do
          expect(fields[:MailingState]).to eq('State')
        end

        it 'can have a ZIP code' do
          expect(fields[:MailingPostalCode]).to eq('Z1PC0D3')
        end

        it 'can have a country' do
          expect(fields[:MailingCountry]).to eq('Country')
        end

        it 'can have a greeting' do
          expect(fields[:Greeting__c]).to eq('Hi')
        end

        it 'can have npe01 fields' do
          expect(fields[:npe01__Private__c]).to be(false)
          expect(fields[:npe01__SystemIsIndividual__c]).to be(true)
        end

        it 'can have preferences' do
          expect(fields[:Do_not_email__c]).to be(false)
        end

        it 'can have personal data' do
          expect(fields[:Couple__c]).to be(false)
          expect(fields[:Deceased__c]).to be(false)
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
