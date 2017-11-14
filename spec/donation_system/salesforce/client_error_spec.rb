# frozen_string_literal: true

require 'donation_system/salesforce/client_error'

module DonationSystem
  module Salesforce
    RSpec.describe ClientError do
      FaradayErrorFake = Struct.new(:response)

      it 'deals with Faraday client errors' do
        response = { body: [{ 'errorCode' => 'SOME_ERROR' }] }
        faraday_error = FaradayErrorFake.new(response)
        errors = ClientError.new(faraday_error).errors
        expect(errors).to eq([:some_error])
      end

      it 'returns nothing if there are no Faraday client errors' do
        response = { body: [] }
        faraday_error = FaradayErrorFake.new(response)
        errors = ClientError.new(faraday_error).errors
        expect(errors).to be_empty
      end

      it 'returns nothing if there is no response body' do
        response = {}
        faraday_error = FaradayErrorFake.new(response)
        errors = ClientError.new(faraday_error).errors
        expect(errors).to be_empty
      end

      it 'returns nothing if there is no response' do
        faraday_error = FaradayErrorFake.new(nil)
        errors = ClientError.new(faraday_error).errors
        expect(errors).to be_empty
      end

      it 'returns nothing if there is no Faraday client error' do
        errors = ClientError.new(nil).errors
        expect(errors).to be_empty
      end
    end
  end
end
