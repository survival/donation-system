# frozen_string_literal: true

require 'salesforce/data_structs_for_tests'
require 'salesforce/supporter_creator'
require 'spec_helper'

module Salesforce
  RSpec.describe SupporterCreator do
    let(:data) { RawSupporterData.new('A Name', 'test@test.com') }

    describe 'when successful', vcr: { record: :once } do
      it 'creates a supporter' do
        result = create_supporter(data)
        expect(result).to be_okay
        expect(result.item[:Email]).to eq('test@test.com')
      end
    end

    describe 'when unsuccessful', vcr: { record: :once } do
      it 'fails if there is no data' do
        result = create_supporter(nil)
        expect(result).not_to be_okay
        expect(result.item).to be_nil
      end

      it 'fails if data is invalid' do
        result = create_supporter(RawSupporterData.new(nil, nil))
        expect(result).not_to be_okay
        expect(result.item).to be_nil
      end

      it 'fails if there is a creation problem' do
        allow(SupporterValidator).to receive(:execute)
          .and_return(Result.new(nil, []))
        result = create_supporter(data)
        expect(result).not_to be_okay
        expect(result.item).to be_nil
      end
    end

    def create_supporter(data)
      client = Restforce.new(host: 'cs70.salesforce.com')
      described_class.execute(data, client)
    end
  end
end
