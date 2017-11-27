# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/database'
require 'donation_system/salesforce/result'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe Database do
      let(:data) { DonationData.new(VALID_REQUEST_DATA, VALID_PAYMENT_DATA) }

      describe 'when sucessful' do
        it 'creates a donation if supporter exists' do
          finder_result = Result.new({ Id: '1234' }, [])
          donation_result = Result.new({ Id: '5678' }, [])

          allow(SupporterFinder).to receive(:execute).and_return(finder_result)
          allow(DonationCreator).to receive(:execute).and_return(donation_result)
          expect(described_class.add_donation(data)).to be_empty
        end

        it 'creates supporter and donation if supporter does not exist' do
          finder_result = Result.new(nil, [])
          creation_result = Result.new({ Id: '1234' }, [])
          donation_result = Result.new({ Id: '5678' }, [])

          allow(SupporterFinder).to receive(:execute).and_return(finder_result)
          allow(SupporterCreator).to receive(:execute).and_return(creation_result)
          allow(DonationCreator).to receive(:execute).and_return(donation_result)
          expect(described_class.add_donation(data)).to be_empty
        end
      end

      describe 'when unsuccessful' do
        it 'returns errors if email is not present' do
          expect(described_class.add_donation(nil)).to eq([:missing_email])

          expect(described_class.add_donation('foo')).to eq([:missing_email])

          data = DonationData.new(nil, VALID_PAYMENT_DATA)
          expect(described_class.add_donation(data)).to eq([:missing_email])
        end

        it 'returns errors if email is null' do
          request_data = VALID_REQUEST_DATA.dup
          request_data.email = nil
          data = DonationData.new(request_data, VALID_PAYMENT_DATA)
          expect(described_class.add_donation(data)).to eq([:missing_email])
        end

        it 'returns errors if problems with finder' do
          finder_result = Result.new(nil, [:finder_error])

          allow(SupporterFinder).to receive(:execute).and_return(finder_result)
          expect(described_class.add_donation(data)).to eq([:finder_error])
        end

        it 'returns errors if problems with supporter creation' do
          finder_result = Result.new(nil, [])
          creation_result = Result.new(nil, [:creation_error])

          allow(SupporterFinder).to receive(:execute).and_return(finder_result)
          allow(SupporterCreator).to receive(:execute).and_return(creation_result)
          expect(described_class.add_donation(data)).to eq([:creation_error])
        end

        it 'returns errors if problems with donation creation' do
          finder_result = Result.new({ Id: '1234' }, [])
          donation_result = Result.new(nil, [:donation_error])

          allow(SupporterFinder).to receive(:execute).and_return(finder_result)
          allow(DonationCreator).to receive(:execute).and_return(donation_result)
          expect(described_class.add_donation(data)).to eq([:donation_error])
        end
      end
    end
  end
end
