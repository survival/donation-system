# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/donation_data'
require 'donation_system/salesforce/supporter_creator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe SupporterCreator do
      let(:data) do
        DonationData.new(VALID_REQUEST_DATA, VALID_ONEOFF_PAYMENT_DATA)
      end

      describe 'when successful', vcr: { record: :once } do
        it 'creates a supporter' do
          result = create_supporter(data)
          expect(result).to be_okay
          expect(result.item[:Email]).to eq('user@example.com')
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        it 'fails if there is no data' do
          result = create_supporter(nil)
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end

        it 'fails if data is invalid' do
          result = create_supporter(nil)
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end

        it 'fails if there is a creation problem' do
          result = create_supporter(data, ClientFake.new(nil, [:creation_error]))
          expect(result).not_to be_okay
          expect(result.item).to be_nil
        end
      end

      def create_supporter(data, client_fake = nil)
        client_default = ClientAPI.new(Restforce.new(host: 'cs70.salesforce.com'))
        client = client_fake || client_default
        described_class.execute(data, client)
      end

      ClientFake = Struct.new(:supporter_id, :errors) do
        def create(_table, _fields)
          supporter_id
        end
      end
    end
  end
end
