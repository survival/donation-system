# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/resulting_adapted_payment_api'

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
