# frozen_string_literal: true

require 'donation_system/salesforce/supporter_finder'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe SupporterFinder do
      describe 'when successful', vcr: { record: :once } do
        it 'returns the supporter if exists' do
          result = search_by(:Email, 'test@test.com')
          expect(result).to be_okay
          expect(result.item[:Email]).to eq('test@test.com')
        end

        it 'picks oldest supporter if several with same email' do
          result = search_by(:Email, 'repeated_email@test.com')
          expect(result).to be_okay
          expect(result.item[described_class::SORT_FIELD]).to eq('2017-08-01')
        end

        it 'returns nothing if no supporter' do
          result = search_by(:Email, 'i-dont-exist@test.com')
          expect(result).to be_okay
          expect(result.item).to be_nil
        end
      end

      describe 'when unsuccessful', vcr: { record: :once } do
        it 'fails if search field does not exist' do
          result = search_by(:foo, 'bar')
          expect(result.item).to be_nil
          expect(result.errors).to eq([:invalid_field])
        end
      end

      def search_by(field, value)
        client = ClientAPI.new(Restforce.new(host: 'cs70.salesforce.com'))
        described_class.execute(field, value, client)
      end
    end
  end
end
