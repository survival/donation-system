# frozen_string_literal: true

require 'spec_helper'
require 'donation_system/data_structs_for_tests'
require 'donation_system/adapters/resulting_adapted_payment_api'

require 'donation_system/adapters/stripe_recurring_salesforce'
require 'donation_system/stripe_wrapper/recurring'

module DonationSystem
  module Adapters
    RSpec.describe StripeRecurringSalesforce, vcr: { record: :once } do
      def payment_data
        stripe_subscription_fake = StripeSubscriptionFake.new(
          'sub_C6wrGA60bGiHfV', 1_510_917_211,
          SubscriptionPlanFake.new(1234, 'gbp'), 'active',
          SubscriptionMetadataFake.new(
            '4242', 'Visa', '8', '2100', 'MC123456789'
          ), 1_510_917_211
        )
        described_class.adapt(stripe_subscription_fake)
      end

      it_behaves_like 'Salesforce one-off payment data'
      it_behaves_like 'Salesforce recurring payment data'

      it 'works with the real object to adapt', vcr: { record: :once } do
        subscription = DonationSystem::StripeWrapper::Recurring.charge(
          VALID_REQUEST_DATA
        )
        payment_data = described_class.adapt(subscription.item)
        expect(payment_data).not_to be_nil
      end

      SubscriptionPlanFake = Struct.new(:amount, :currency)
      SubscriptionMetadataFake = Struct.new(
        :last4, :brand, :expiry_month, :expiry_year, :number
      )
      StripeSubscriptionFake = Struct.new(
        :id, :created, :plan, :status, :metadata, :current_period_start
      )
    end
  end
end
