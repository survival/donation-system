# frozen_string_literal: true

module DonationSystem
  module Adapters
    class StripeRecurringSalesforce
      RECEIVED_STATUS = 'active'
      PAYMENT_METHOD = 'Card (Stripe)'
      RECORD_TYPE_ID = '01280000000Fvsz'

      def self.adapt(subscription)
        new(subscription)
      end

      def initialize(subscription)
        @subscription = subscription
      end

      extend Forwardable
      def_delegators :@subscription,
                     :id, :created

      def amount
        subscription.plan.amount
      end

      def currency
        subscription.plan.currency
      end

      def received?
        subscription.status == RECEIVED_STATUS
      end

      def last4
        subscription.metadata.last4
      end

      def brand
        subscription.metadata.brand
      end

      def expiry_month
        subscription.metadata.expiry_month
      end

      def expiry_year
        subscription.metadata.expiry_year
      end

      def method
        PAYMENT_METHOD
      end

      def record_type_id
        RECORD_TYPE_ID
      end

      def number
        subscription.metadata.number
      end

      def start_date
        subscription.current_period_start || subscription.created
      end

      def reference; end

      def collection_day; end

      def mandate_method; end

      def account_holder_name; end

      def oneoff?
        false
      end

      private

      attr_reader :subscription
    end
  end
end
