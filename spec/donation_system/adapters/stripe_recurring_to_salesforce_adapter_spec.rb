# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/payment_adapted_to_salesforce_api'

require 'donation_system/adapters/stripe_recurring_salesforce'
require 'donation_system/stripe_wrapper/recurring'

module DonationSystem
  module Adapters
    RSpec.describe StripeRecurringSalesforce, vcr: { record: :once } do
      let(:payment_data) do
        described_class.adapt(VALID_REQUEST_DATA, VALID_STRIPE_SUBSCRIPTION)
      end

      it_behaves_like 'Input payment data'
      it_behaves_like 'Salesforce one-off payment data'
      it_behaves_like 'Salesforce recurring payment data'

      it 'has last four digits of the card' do
        expect(payment_data.last4).to eq('4242')
      end

      it 'has a card brand' do
        expect(payment_data.brand).to eq('Visa')
      end

      it 'works with the real object to adapt', vcr: { record: :once } do
        subscription = DonationSystem::StripeWrapper::Recurring.charge(
          VALID_REQUEST_DATA
        )
        payment_data = described_class.adapt(
          VALID_REQUEST_DATA, subscription.item
        )
        expect(payment_data).not_to be_nil
      end
    end
  end
end
