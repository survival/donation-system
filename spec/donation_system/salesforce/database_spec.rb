# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/result'
require 'donation_system/salesforce/database'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe Database do
      let(:data) { VALID_ONEOFF_PAYMENT_DATA }

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
        it 'returns errors if data is invalid' do
          expect(described_class.add_donation(nil)).to include(:invalid_email)
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
