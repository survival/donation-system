# frozen_string_literal: true

require 'money'
require_relative '../result'

module DonationSystem
  module StripeWrapper
    class FieldsGenerator
      def initialize(data)
        @data = data
      end

      def for_charge
        {
          amount: amount_in_cents,
          currency: data.currency,
          source: data.token,
          description: "Charge for #{data.email}",
          metadata: { number: generate_number('P') }
        }
      end

      def for_plan
        {
          id: "mandate_#{mandate_number}",
          name: "Mandate #{mandate_number}",
          amount: amount_in_cents,
          currency: 'gbp',
          interval: 'month',
          interval_count: 1
        }
      end

      def for_customer
        {
          email: data.email,
          source: data.token,
          description: "Customer for #{data.email}"
        }
      end

      def for_subscription(plan, customer)
        {
          customer: customer.id,
          items: [{ plan: plan.id }],
          metadata: subscription_metadata(plan, customer)
        }
      end

      private

      attr_reader :data

      def amount_in_cents
        Money.from_amount(BigDecimal(data.amount).abs, data.currency).cents
      end

      def generate_number(number_prefix)
        number_prefix + Array.new(9) { Random.rand(9) }.join
      end

      def subscription_metadata(plan, customer)
        card = card_data(customer)
        {
          description: "#{data.email} paying for mandate #{plan.id}",
          mandate: plan.id,
          number: mandate_number,
          last4: card.last4,
          brand: card.brand,
          expiry_month: card.exp_month,
          expiry_year: card.exp_year
        }
      end

      def mandate_number
        @mandate_number ||= generate_number('MC')
      end

      def card_data(customer)
        customer.sources.data.first
      end
    end
  end
end
