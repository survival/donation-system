# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/salesforce/supporter_creator'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe SupporterCreator do
      let(:data) { VALID_ONEOFF_PAYMENT_DATA }

      describe 'when successful', vcr: { record: :once } do
        it 'creates a supporter' do
          result = create_supporter(data)
          expect(result).to be_okay
          expect(result.item[:Email]).to eq('user@example.com')
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
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
