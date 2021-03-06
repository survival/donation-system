# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/payment_adapted_to_salesforce_api'

require 'donation_system/adapters/stripe_one_off_salesforce'
require 'donation_system/stripe_wrapper/one_off'

module DonationSystem
  module Adapters
    RSpec.describe StripeOneOffSalesforce do
      let(:payment_data) do
        described_class.adapt(VALID_REQUEST_DATA, VALID_STRIPE_CHARGE)
      end

      it_behaves_like 'Input payment data'
      it_behaves_like 'Salesforce one-off payment data'

      it 'has last four digits of the card' do
        expect(payment_data.last4).to eq('4242')
      end

      it 'has a card brand' do
        expect(payment_data.brand).to eq('Visa')
      end

      it 'works with the real object to adapt', vcr: { record: :once } do
        charge = DonationSystem::StripeWrapper::OneOff.charge(VALID_REQUEST_DATA)
        payment_data = described_class.adapt(VALID_REQUEST_DATA, charge.item)
        expect(payment_data).not_to be_nil
      end
    end
  end
end
