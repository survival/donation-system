# frozen_string_literal: true

module DonationSystem
  module Adapters
    class StripeOneOffSalesforce
      RECEIVED_STATUS = 'succeeded'
      PAYMENT_METHOD = 'Card (Stripe)'
      RECORD_TYPE_ID = '01280000000Fvqi'

      def self.adapt(charge)
        new(charge)
      end

      def initialize(charge)
        @charge = charge
      end

      extend Forwardable
      def_delegators :@charge,
                     :id, :amount, :currency, :created

      def received?
        charge.status == RECEIVED_STATUS
      end

      def last4
        charge.source.last4
      end

      def brand
        charge.source.brand
      end

      def method
        PAYMENT_METHOD
      end

      def record_type_id
        RECORD_TYPE_ID
      end

      def number
        charge.metadata.number
      end

      def oneoff?
        true
      end

      private

      attr_reader :charge
    end
  end
end
