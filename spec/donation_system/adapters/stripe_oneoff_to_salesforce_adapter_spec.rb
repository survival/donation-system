# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/resulting_adapted_payment_api'

require 'donation_system/adapters/stripe_one_off_salesforce'
require 'donation_system/stripe_wrapper/one_off'

module DonationSystem
  module Adapters
    RSpec.describe StripeOneOffSalesforce do
      def payment_data
        stripe_charge_fake = StripeChargeFake.new(
          'ch_1BPDARGjXKYZTzxWrD35FFDc', 1234, 'gbp', 1_510_917_211,
          'succeeded', ChargeSourceFake.new('4242', 'Visa'),
          ChargeMetadataFake.new('P123456789')
        )
        described_class.adapt(stripe_charge_fake)
      end

      it_behaves_like 'Salesforce payment data'

      it 'works with the real object to adapt', vcr: { record: :once } do
        charge = DonationSystem::StripeWrapper::OneOff.charge(VALID_REQUEST_DATA)
        payment_data = described_class.adapt(charge.item)
        expect(payment_data).not_to be_nil
      end

      ChargeSourceFake = Struct.new(:last4, :brand)
      ChargeMetadataFake = Struct.new(:number)
      StripeChargeFake = Struct.new(
        :id, :amount, :currency, :created, :status, :source, :metadata
      )
    end
  end
end
