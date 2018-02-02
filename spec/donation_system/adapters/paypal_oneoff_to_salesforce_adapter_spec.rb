# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/payment_adapted_to_salesforce_api'

require 'donation_system/adapters/paypal_one_off_salesforce'
require 'donation_system/paypal_wrapper/one_off'

module DonationSystem
  module Adapters
    RSpec.describe PaypalOneOffSalesforce do
      let(:payment_data) do
        described_class.adapt(VALID_REQUEST_DATA, VALID_PAYPAL_PAYMENT)
      end

      it_behaves_like 'Input payment data'
      it_behaves_like 'Salesforce one-off payment data'

      it 'does not have a card number' do
        expect(payment_data.last4).to be_nil
      end

      it 'does not have a card brand' do
        expect(payment_data.brand).to be_nil
      end
    end
  end
end
