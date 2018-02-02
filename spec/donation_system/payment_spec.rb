# frozen_string_literal: true

require 'donation_system/data_structs_for_tests'
require 'donation_system/payment'
require 'spec_helper'

module DonationSystem
  RSpec.describe Payment do
    describe 'when the gateway is unsuccessful' do
      it 'returns the gateway error' do
        result = Result.new(nil, [:error])
        allow(PaymentGateway).to receive(:charge).and_return(result)
        expect(described_class.attempt(VALID_REQUEST_DATA)).to eq([:error])
      end
    end

    describe 'when the gateway is successful' do
      let(:result) { Result.new(VALID_STRIPE_CHARGE, []) }

      before do
        allow(PaymentGateway).to receive(:charge).and_return(result)
        allow(ThankYouMailer).to receive(:send_email)
        allow(Salesforce::Database).to receive(:add_donation).and_return([])
        allow(Selector).to receive(:select_adapter).and_return(AdapterFake)
      end

      it 'returns errors if there is a problem with the supporter database' do
        errors = %i[foo bar]
        allow(Salesforce::Database).to receive(:add_donation).and_return(errors)
        expect(described_class.attempt(VALID_REQUEST_DATA)).to eq(errors)
      end

      it 'succeeds if there are no problems with the supporter database' do
        expect(described_class.attempt(VALID_REQUEST_DATA)).to be_empty
      end

      it 'sends a thank you email' do
        described_class.attempt(VALID_REQUEST_DATA)
        expect(ThankYouMailer).to have_received(:send_email)
          .with('user@example.com', 'Firstname Lastname')
      end

      it 'adds the donation to the supporters database' do
        described_class.attempt(VALID_REQUEST_DATA)
        expect(Salesforce::Database).to have_received(:add_donation)
          .with(VALID_ONEOFF_PAYMENT_DATA)
      end

      class AdapterFake
        def self.adapt(_data, _item)
          VALID_ONEOFF_PAYMENT_DATA
        end
      end
    end
  end
end
