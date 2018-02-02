# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/resulting_adapted_payment_api'

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

      it 'works with the real object to adapt', vcr: { record: :once } do
        charge = DonationSystem::StripeWrapper::OneOff.charge(VALID_REQUEST_DATA)
        payment_data = described_class.adapt(VALID_REQUEST_DATA, charge.item)
        expect(payment_data).not_to be_nil
      end
    end
  end
end
