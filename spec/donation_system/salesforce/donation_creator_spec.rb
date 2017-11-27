# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/salesforce/donation_creator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe DonationCreator do
      let(:data) { RawDonationData.new('2000') }
      let(:supporter) { SupporterFake.new('0013D00000LBYutQAH') }

      describe 'when successful', vcr: { record: :once } do
        it 'creates a donation' do
          result = create_donation(data, supporter)
          expect(result).to be_okay
          expect(result.item).not_to be_nil
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        it 'fails if data is invalid' do
          result = create_donation(nil, supporter)
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end

        it 'fails if supporter is invalid' do
          result = create_donation(data, nil)
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end

        it 'fails if there is a creation problem' do
          result = create_donation(data, SupporterFake.new('1234'))
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end
      end

      def create_donation(data, supporter)
        client = ClientAPI.new(Restforce.new(host: 'cs70.salesforce.com'))
        described_class.execute(data, supporter, client)
      end
    end
  end
end
