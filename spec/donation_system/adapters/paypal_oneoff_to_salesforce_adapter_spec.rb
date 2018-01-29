# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/resulting_adapted_payment_api'

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
    end
  end
end
