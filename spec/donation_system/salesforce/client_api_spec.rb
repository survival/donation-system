# frozen_string_literal: true

require 'donation_system/salesforce/client_api'
require 'spec_helper'

module DonationSystem
  module Salesforce
    RSpec.describe ClientAPI do
      let(:client) { double(Restforce) }
      let(:client_api) { described_class.new(client) }

      describe 'when successful' do
        it 'can search' do
          expect(client).to receive(:query).with('search query')
          client_api.search('search query')
        end

        it 'can create a Salesforce object' do
          expect(client).to receive(:create!).with('table', {})
          client_api.create('table', {})
        end

        it 'can fetch a Salesforce object' do
          expect(client).to receive(:find).with('table', 'id')
          client_api.fetch('table', 'id')
        end
      end

      describe 'when unsuccessful' do
        let(:response) { { body: [{ 'errorCode' => 'SOME_ERROR' }] } }

        it 'can have search errors' do
          allow(client).to receive(:query).and_raise(
            Faraday::ClientError, response
          )
          expect(client_api.search('I throw an error')).to be_nil
          expect(client_api.errors).not_to be_empty
        end

        it 'can have Salesforce object creation errors' do
          expect(client).to receive(:create!).and_raise(
            Faraday::ClientError, response
          )
          expect(client_api.create('i-dont-exist', {})).to be_nil
          expect(client_api.errors).not_to be_empty
        end

        it 'can have unknown object creation errors' do
          expect(client).to receive(:create!).and_raise(StandardError)
          expect(client_api.create('table', {})).to be_nil
          expect(client_api.errors).not_to be_empty
        end
      end
    end
  end
end
