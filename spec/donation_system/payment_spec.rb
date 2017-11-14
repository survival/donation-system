# frozen_string_literal: true

require 'donation_system/payment'
require 'donation_system/salesforce/database'
require 'donation_system/stripe_wrapper/gateway'
require 'donation_system/thank_you_mailer'
require 'spec_helper'

module DonationSystem
  RSpec.describe Payment do
    Request = Struct.new(:email, :name)

    let(:request) { Request.new('user@example.com', 'Name') }

    describe 'when the gateway is unsuccessful' do
      it 'returns the gateway error' do
        result = StripeWrapper::Result.new(nil, [:error])
        allow(StripeWrapper::Gateway).to receive(:charge).and_return(result)
        expect(described_class.attempt(request)).to eq([:error])
      end
    end

    describe 'when the gateway is successful' do
      let(:result) { StripeWrapper::Result.new('irrelevant', []) }

      before do
        allow(StripeWrapper::Gateway).to receive(:charge).and_return(result)
        allow(Salesforce::Database).to receive(:add_donation).and_return([])
      end

      it 'returns errors if there is a problem with the supporter database' do
        errors = %i[foo bar]
        allow(Salesforce::Database).to receive(:add_donation).and_return(errors)
        expect(described_class.attempt(request)).to eq(errors)
      end

      it 'succeeds if there are no problems with the supporter database' do
        expect(described_class.attempt(request)).to be_empty
      end

      it 'sends a thank you email' do
        allow(ThankYouMailer).to receive(:send_email)
        described_class.attempt(request)
        expect(ThankYouMailer).to have_received(:send_email)
          .with('user@example.com', 'Name')
      end

      it 'adds the donation to the supporters database' do
        described_class.attempt(request)
        expect(Salesforce::Database).to have_received(:add_donation)
          .with(request)
      end
    end
  end
end
