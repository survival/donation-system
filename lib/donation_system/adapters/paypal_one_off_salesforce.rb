# frozen_string_literal: true

require 'date'
require 'money'

module DonationSystem
  module Adapters
    class PaypalOneOffSalesforce
      RECEIVED_STATUS = 'approved'
      PAYMENT_METHOD = 'PayPal'
      RECORD_TYPE_ID = '01280000000Fxfp'

      def self.adapt(data, payment)
        new(data, payment)
      end

      def initialize(data, payment)
        @data = data
        @payment = payment
      end

      extend Forwardable
      def_delegators :@data,
                     :type, :giftaid

      def_delegators :@payment,
                     :id

      def amount
        amount_as_number = BigDecimal(payment_data.total).abs
        I18n.enforce_available_locales = false
        Money.from_amount(amount_as_number, payment_data.currency).cents
      end

      def currency
        Money::Currency.new(payment_data.currency).to_s.downcase
      end

      def name
        "#{payer_info.first_name} #{payer_info.last_name}"
      end

      def email
        payer_info.email
      end

      def address
        shipping_address.line1
      end

      def city
        shipping_address.city
      end

      def state
        shipping_address.state
      end

      def zip
        shipping_address.postal_code
      end

      def country
        shipping_address.country_code
      end

      def created
        Time.new(payment.create_time).to_i
      end

      def received?
        payment.state == RECEIVED_STATUS
      end

      def last4
        nil
      end

      def brand
        nil
      end

      def method
        PAYMENT_METHOD
      end

      def record_type_id
        RECORD_TYPE_ID
      end

      def number
        payment.transactions.first.description
      end

      def oneoff?
        true
      end

      private

      attr_reader :data, :payment

      def payment_data
        payment.transactions.first.amount
      end

      def payer_info
        payment.payer.payer_info
      end

      def shipping_address
        payment.payer.payer_info.shipping_address
      end
    end
  end
end
